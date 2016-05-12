class Agreement < ActiveRecord::Base
  belongs_to :proposal

  validates :agreement_type, presence: true
  validates :proposal, presence: true

  scope :potential, -> { where(state: "potential") }
  scope :active, -> { where(state: "active") }
  scope :inactive, -> { where(state: "inactive") }

  state_machine initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition potential: :active, do: :mark_proposal_active
    after_transition active: :inactive, do: :mark_proposal_inactive

    event :mark_active do
      transition potential: :active, if: lambda { |agreement| agreement.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |agreement| agreement.meets_requirements_active? }
    end

  end

  def items
    proposal.items.where(client_intention: agreement_type)
  end

  def mark_proposal_active
    proposal.mark_active!
  end

  def mark_proposal_inactive
    proposal.mark_inactive!
  end

  def meets_requirements_active?
    if agreement_type == "consign"
      client_signature.present? && manager_signature.present?
    else
      client_signature.present?
    end
  end

end
