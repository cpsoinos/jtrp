class Proposal < ActiveRecord::Base
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :created_by, class_name: "User"
  has_many :items

  validates :client, presence: true
  validates :created_by, presence: true
end
