class Account < ActiveRecord::Base
  has_many :clients
  belongs_to :primary_contact, class_name: "Client", foreign_key: "primary_contact_id"
  has_many :jobs
  has_many :proposals, through: :jobs
  has_many :items, through: :proposals
  belongs_to :created_by, class_name: "InternalUser", foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "InternalUser", foreign_key: "updated_by_id"

  validates :account_number, uniqueness: true
  validates :status, presence: true

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  before_create :set_account_number
  after_create :increment_system_info

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    event :mark_active do
      transition potential: :active, if: lambda { |account| account.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |account| account.meets_requirements_inactive? }
    end

    after_transition potential: :active, do: :mark_clients_active
    after_transition active: :inactive, do: :mark_clients_inactive

  end

  alias :client :primary_contact

  delegate :full_name, to: :primary_contact

  def meets_requirements_active?
    jobs.active.present?
  end

  def meets_requirements_inactive?
    jobs.present? && jobs.complete.count == jobs.count
  end

  def mark_clients_active
    clients.map(&:mark_active)
  end

  def mark_clients_inactive
    clients.map(&:mark_inactive)
  end

  def self.yard_sale
    Account.find_by(account_number: 1)
  end

  def self.estate_sale
    Account.find_by(account_number: 2)
  end

  def yard_sale?
    account_number == 1 && company_name == "Yard Sale"
  end

  def estate_sale?
    account_number == 2 && company_name == "Estate Sale"
  end

  private

  def set_account_number
    self.account_number = SystemInfo.first.last_account_number
  end

  def increment_system_info
    SystemInfo.first.increment!(:last_account_number)
  end

end
