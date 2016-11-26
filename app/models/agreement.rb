class Agreement < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :proposal
  has_secure_token

  include Filterable

  belongs_to :proposal, touch: true
  has_many :items, -> (instance) { where(items: {client_intention: instance.agreement_type}).where.not(items: {status: 'expired'}) }, through: :proposal
  has_one :scanned_agreement
  has_many :statements
  has_one :job, through: :proposal
  has_one :account, through: :job
  has_many :letters

  after_destroy :delete_cache

  validates :agreement_type, presence: true
  validates :proposal, presence: true

  scope :status, -> (status) { where(status: status) }
  scope :by_type, -> (type) { where(agreement_type: type) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  monetize :service_charge_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition potential: :active, do: [:mark_proposal_active, :set_agreement_date, :save_as_pdf, :notify_company]
    after_transition active: :inactive, do: :mark_proposal_inactive

    event :mark_active do
      transition [:potential, :inactive] => :active, if: lambda { |agreement| agreement.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |agreement| agreement.meets_requirements_inactive? }
    end

  end

  def short_name
    "#{account.short_name} #{agreement_type}"
  end

  def humanized_agreement_type
    if agreement_type == "consign"
      "Consignment Agreement"
    elsif agreement_type == "sell"
      "Purchase Invoice"
    end
  end

  def mark_items_active
    items.map(&:mark_active)
  end

  def mark_proposal_active
    proposal.mark_active if proposal.potential?
  end

  def mark_proposal_inactive
    proposal.mark_inactive
  end

  def set_agreement_date
    self.date = DateTime.now
    self.save
  end

  def meets_requirements_active?
    client_signed?
  end

  def meets_requirements_inactive?
    items.active.empty?
  end

  def meets_requirements_expired?
    agreement_type == "consign" &&
    items.active.none? { |i| i.listed_at < 90.days.ago }
  end

  def manager_signed?
    manager_agreed? || scanned_agreement.present?
  end

  def client_signed?
    client_agreed? || scanned_agreement.present?
  end

  def object_url
    Rails.application.routes.url_helpers.agreement_url(self, token: token, host: ENV['HOST'])
  end

  def save_as_pdf
    unless scanned_agreement.present?
      PdfGeneratorJob.perform_later(self)
    end
  end

  def notify_company
    return unless self.active?
    TransactionalEmailJob.perform_later(self, account.primary_contact, proposal.created_by, "agreement_active_notifier")
  end

  def task
    if meets_requirements_expired?
      { name: "expire agreement", description: "is more than 90 days old" }
    else
      { name: "notify client", description: "needs to be notified that their consignment period is ending soon" }
    end
  end

  private

  def update_cache
    Rails.cache.write("#{proposal.cache_key}/#{agreement_type}_agreement", self)
  end

  def delete_cache
    Rails.cache.delete("#{proposal.cache_key}/#{agreement_type}_agreement")
  end

end
