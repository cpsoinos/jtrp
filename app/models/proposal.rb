class Proposal < ActiveRecord::Base
  belongs_to :account
  belongs_to :created_by, class_name: "User"
  has_many :items
  has_many :agreements

  validates :account, presence: true
  validates :created_by, presence: true

  scope :potential, -> { where(state: "potential") }
  scope :active, -> { where(state: "active") }
  scope :inactive, -> { where(state: "inactive") }

  state_machine initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition potential: :active, do: [:mark_items_active, :mark_client_active]
    after_transition active: :inactive, do: :mark_client_inactive

    event :mark_active do
      transition potential: :active, if: lambda { |proposal| proposal.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |proposal| proposal.meets_requirements_inactive? }
    end

  end

  def client
    account.primary_contact
  end

  def meets_requirements_active?
    agreements.active.present?
  end

  def meets_requirements_inactive?
    !agreements.active.present? && !items.active.present?
  end

  def mark_items_active
    items.each do |item|
      item.mark_active
    end
  end

  def mark_client_active
    client.mark_active
  end

  def mark_client_inactive
    client.mark_inactive
  end

  def client
    account.primary_contact
  end

end
