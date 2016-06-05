class Job < ActiveRecord::Base
  belongs_to :account
  has_many :proposals, dependent: :destroy
  has_many :items, through: :proposals

  validates :account, presence: true

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :complete

    after_transition potential: :active, do: :mark_account_active
    after_transition active: :complete, do: :mark_account_inactive

    event :mark_active do
      transition potential: :active, if: lambda { |job| job.meets_requirements_active? }
    end

    event :mark_complete do
      transition active: :complete, if: lambda { |job| job.meets_requirements_complete? }
    end
  end

  def meets_requirements_active?
    proposals.active.present?
  end

  def meets_requirements_complete?
    proposals.present? && proposals.inactive.count == proposals.count
  end

  def mark_account_active
    if !account.active?
      account.mark_active!
    end
  end

  def mark_account_inactive
    account.mark_inactive
  end

end
