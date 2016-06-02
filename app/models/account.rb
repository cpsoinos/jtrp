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

  private

  def set_account_number
    self.account_number = SystemInfo.first.last_account_number
  end

  def increment_system_info
    SystemInfo.first.increment!(:last_account_number)
  end

end
