class PurchaseOrder < ActiveRecord::Base
  belongs_to :vendor, class_name: "User", foreign_key: "vendor_id"
  belongs_to :created_by, class_name: "User"
  has_many :items

  validates :vendor, presence: true
  validates :created_by, presence: true
end
