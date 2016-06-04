class Account < ActiveRecord::Base
  has_many :clients
  belongs_to :primary_contact, class_name: "Client", foreign_key: "primary_contact_id"
  has_many :proposals
  has_many :items
  belongs_to :created_by, class_name: "InternalUser", foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "InternalUser", foreign_key: "updated_by_id"

  validates :account_number, uniqueness: true

  before_create :set_account_number
  after_create :increment_system_info

  alias :client :primary_contact

  delegate :full_name, to: :primary_contact

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
