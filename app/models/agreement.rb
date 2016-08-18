class Agreement < ActiveRecord::Base
  include Filterable

  belongs_to :proposal
  has_one :scanned_agreement

  validates :agreement_type, presence: true
  validates :proposal, presence: true

  scope :status, -> (status) { where(status: status) }
  scope :by_type, -> (type) { where(agreement_type: type) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition potential: :active, do: [:mark_items_active, :mark_proposal_active, :set_agreement_date]
    after_transition active: :inactive, do: :mark_proposal_inactive

    event :mark_active do
      transition potential: :active, if: lambda { |agreement| agreement.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |agreement| agreement.meets_requirements_inactive? }
    end

  end

  delegate :account, to: :proposal
  delegate :job, to: :proposal

  def items
    proposal.items.where(client_intention: agreement_type)
  end

  def mark_items_active
    items.map(&:mark_active)
  end

  def mark_proposal_active
    proposal.mark_active if proposal.potential?
  end

  def mark_proposal_inactive
    proposal.mark_inactive!
  end

  def set_agreement_date
    self.date = DateTime.now
    self.save
  end

  def meets_requirements_active?
    if agreement_type == "consign"
      manager_signed? && client_signed?
    else
      client_signed?
    end
  end

  def meets_requirements_inactive?
    items.active.empty?
  end

  def manager_signed?
    manager_agreed? || scanned_agreement.present?
  end

  def client_signed?
    client_agreed? || scanned_agreement.present?
  end

end
