class Job < ActiveRecord::Base
  include Filterable

  belongs_to :account
  has_many :proposals, dependent: :destroy
  has_many :items, through: :proposals
  has_many :agreements, through: :proposals

  validates :account, presence: true

  scope :account_id, -> (account_id) { where(account_id: account_id) }
  scope :status, -> (status) { where(status: status) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :completed, -> { where(status: "completed") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :completed

    after_transition potential: :active, do: :mark_account_active
    after_transition active: :completed, do: :mark_account_inactive

    event :mark_active do
      transition potential: :active, if: lambda { |job| job.meets_requirements_active? }
    end

    event :mark_completed do
      transition active: :completed, if: lambda { |job| job.meets_requirements_completed? }
    end
  end

  def meets_requirements_active?
    proposals.active.present?
  end

  def meets_requirements_completed?
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

  def maps_url
    GeolocationService.new(self).static_map_url
  end

  def name
    "#{account.short_name} - #{address_1}"
  end

end
