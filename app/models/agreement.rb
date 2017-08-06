class Agreement < ActiveRecord::Base
  include PublicActivity::Common
  include AgreementStateMachine
  include Filterable

  acts_as_paranoid
  acts_as_taggable_on :tags
  audited associated_with: :proposal
  has_secure_token

  mount_uploader :pdf, PdfUploader

  belongs_to :proposal, touch: true
  has_many :items, -> (instance) { where(items: {client_intention: instance.agreement_type, parent_item_id: nil}).where.not(items: {expired: 'true'}) }, through: :proposal
  has_one :scanned_agreement
  has_one :job, through: :proposal
  has_one :account, through: :job
  has_many :letters
  belongs_to :created_by, class_name: "User"
  belongs_to :updated_by, class_name: "User"

  after_destroy :delete_cache

  validates :agreement_type, presence: true
  validates :proposal, presence: true

  scope :status, -> (status) { where(status: status) }
  scope :by_type, -> (type) { where(agreement_type: type) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }
  scope :unexpireable, -> { joins(:tags).where(tags: { name: 'unexpireable' }) }

  monetize :service_charge_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  def short_name
    "#{account.short_name}_#{agreement_type}"
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

  def date_or_created_at
    date || created_at
  end

  def set_agreement_date
    self.date = DateTime.now
    self.save
  end

  def meets_requirements_expired?
    agreement_type == "consign" &&
      active?                   &&
      items.meets_requirements_expired.present?
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
    PdfGeneratorJob.perform_later(self)
  end

  def notify_company
    return unless self.active?
    Notifier.send_agreement_active_notification(self).deliver_later
  end

  def task
    if meets_requirements_expired?
      { name: "expire agreement", description: "is more than 90 days old" }
    else
      { name: "notify client", description: "needs to be notified that their consignment period is ending soon" }
    end
  end

  def cost_of_items
    if agreement_type == "sell"
      Money.new(items.sum(:purchase_price_cents))
    else
      Money.new(0)
    end
  end

  def total_price
    cost_of_items - service_charge
  end

  def notify_pending_expiration
    ConsignmentPeriodEndingNotifierJob.perform_later(self, "agreement_pending_expiration")
  end

  def notify_expiration
    ConsignmentPeriodEndingNotifierJob.perform_later(self, "agreement_expired")
  end

  def expire
    ItemExpirerJob.perform_later(@agreement.items.pluck(:id))
  end

  def pending_expiration_letter
    letters.by_category("agreement_pending_expiration").first
  end

  def expiration_letter
    letters.by_category("agreement_expired").first
  end

  def unexpireable?
    "unexpireable".in?(tag_list)
  end

  def deliver_to_client
    return if should_not_auto_deliver?
    Notifier.send_executed_agreement(self).deliver_later
  end

  private

  def update_cache
    Rails.cache.write("#{proposal.cache_key}/#{agreement_type}_agreement", self)
  end

  def delete_cache
    Rails.cache.delete("#{proposal.cache_key}/#{agreement_type}_agreement")
  end

  def save_item_descriptions
    items.each do |item|
      item.original_description = item.description
      item.save
    end
  end

  def should_not_auto_deliver?
    updated_by.try(:internal?)
  end

end
