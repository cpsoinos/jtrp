class Company < ActiveRecord::Base
  include Bootsy::Container
  mount_uploader :logo, LogoUploader

  has_many :internal_users

  validates :name, presence: true

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}"
  end

  def primary_contact
    internal_users.find_by(primary_contact: true)
  end

end
