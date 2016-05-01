class Proposal < ActiveRecord::Base
  belongs_to :client
  belongs_to :created_by, class_name: "User"
  has_many :items

  validates :client, presence: true
  validates :created_by, presence: true

  scope :potential, -> { where(state: "potential") }
  scope :active, -> { where(state: "active") }
  scope :inactive, -> { where(state: "inactive") }

  state_machine initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition active: :inactive, do: :check_client_state

    event :mark_active do
      transition potential: :active, if: lambda { |proposal| proposal.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |proposal| proposal.meets_requirements_active? }
    end

  end

  def meets_requirements_active?
    client_signature.present? && manager_signature.present?
  end

  def meets_requirements_inactive?
    !items.active.present?
  end

  def check_client_state
    if client.proposals.active.empty?
      client.mark_inactive
    end
  end

end
