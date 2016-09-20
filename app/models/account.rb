class Account < ActiveRecord::Base
  include Filterable
  include PgSearch

  self.inheritance_column = :type
  def self.types
    %w(Owner Customer)
  end

  multisearchable against: [:account_number, :full_name, :status]

  has_many :clients
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id"
  has_many :jobs, dependent: :destroy
  has_many :proposals, through: :jobs
  has_many :items, -> { where.not(client_intention: 'sell', status: ['active', 'sold', 'inactive']) }, through: :proposals
  has_many :agreements, through: :proposals
  has_many :statements, through: :agreements
  belongs_to :created_by, class_name: "InternalUser", foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "InternalUser", foreign_key: "updated_by_id"

  validates :account_number, uniqueness: true
  validates :status, presence: true
  validates :type, presence: true

  scope :status, -> (status) { where(status: status) }

  scope :owner, -> { where(type: "Owner") }
  scope :customer, -> { where(type: "Customer") }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  before_create :set_account_number
  after_create :increment_system_info

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    after_transition potential: :inactive, do: :deactivate_items

    event :mark_active do
      transition potential: :active, if: lambda { |account| account.meets_requirements_active? }
    end

    event :mark_inactive do
      transition active: :inactive, if: lambda { |account| account.meets_requirements_inactive? }
      transition potential: :inactive
    end

  end

  alias :client :primary_contact
  delegate :full_address, to: :primary_contact
  delegate :phone, to: :primary_contact
  delegate :email, to: :primary_contact

  def self.yard_sale
    Account.find_by(account_number: 1)
  end

  def self.estate_sale
    Account.find_by(account_number: 2)
  end

  def full_name
    if company_name.present?
      company_name
    elsif primary_contact.present?
      primary_contact.full_name
    else
      "No Name Provided"
    end
  end

  def short_name
    if company_name.present?
      company_name
    elsif primary_contact.present?
      primary_contact.last_name
    else
      "No Name Provided"
    end
  end

  def avatar
    if primary_contact.present? && primary_contact.avatar.present?
      primary_contact.avatar_url(client_hints: true, quality: "auto", fetch_format: :auto, dpr: "auto")
    else
      ActionController::Base.helpers.asset_path("thumb_default_avatar.png")
    end
  end

  def self.default_url
    ActionController::Base.helpers.asset_path("thumb_No_Image_Available.png")
  end

  def meets_requirements_active?
    jobs.active.present?
  end

  def meets_requirements_inactive?
    jobs.present? && jobs.completed.count == jobs.count
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

  def deactivate_items
    items.each do |item|
      next if item.owned?
      item.mark_inactive
    end
  end

end

class Customer < Account; end
