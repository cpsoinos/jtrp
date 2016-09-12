class Company < ActiveRecord::Base
  include Bootsy::Container
  mount_uploader :logo, PhotoUploader

  acts_as_paranoid

  has_many :internal_users
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id"

  validates :name, presence: true

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}"
  end

end
