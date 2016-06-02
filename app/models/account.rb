class Account < ActiveRecord::Base
  has_many :clients
  belongs_to :primary_contact, class_name: "Client", foreign_key: "primary_contact_id"
  has_many :proposals
  has_many :items, through: :proposals
  belongs_to :created_by, class_name: "InternalUser", foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "InternalUser", foreign_key: "updated_by_id"

  validates :account_number, uniqueness: true

  def primary_contact
    clients.find_by(primary_contact: true)
  end
end
