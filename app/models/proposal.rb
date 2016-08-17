class Proposal < ActiveRecord::Base
  belongs_to :job
  belongs_to :created_by, class_name: "User"
  has_many :items, dependent: :destroy
  has_many :agreements, dependent: :destroy
  has_many :photos

  delegate :account, to: :job

  validates :job, presence: true
  validates :created_by, presence: true

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition potential: :active, do: :mark_job_active
    after_transition active: :inactive, do: :mark_job_complete

    event :mark_active do
      transition potential: :active, if: lambda { |proposal| proposal.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |proposal| proposal.meets_requirements_inactive? }
    end
  end

  delegate :client, to: :account

  def meets_requirements_active?
    agreements.active.present?
  end

  def meets_requirements_inactive?
    !agreements.active.present? && !items.active.present?
  end

  def mark_items_active
    items.each do |item|
      item.mark_active!
    end
  end

  def mark_job_active
    job.mark_active!
  end

  def mark_job_complete
    job.mark_completed!
  end

end
