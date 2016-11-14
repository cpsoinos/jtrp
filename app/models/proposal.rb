class Proposal < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :job
  has_secure_token

  belongs_to :job, touch: true
  belongs_to :created_by, class_name: "User"
  has_many :items, dependent: :destroy
  has_many :agreements, dependent: :destroy
  has_many :photos
  has_one :account, through: :job
  has_one :primary_contact, through: :account

  validates :job, presence: true
  validates :created_by, presence: true

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition [:potential, :inactive] => :active, do: :mark_job_active
    after_transition active: :inactive, do: :mark_job_complete

    event :mark_active do
      transition potential: :active, if: lambda { |proposal| proposal.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |proposal| proposal.meets_requirements_inactive? }
    end
  end

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
    job.mark_active! unless job.active?
  end

  def mark_job_complete
    job.mark_completed!
  end

  def object_url
    Rails.application.routes.url_helpers.account_job_proposal_url(account, job, self, token: token, host: ENV['HOST'])
  end

end
