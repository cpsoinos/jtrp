class Company < ActiveRecord::Base
  acts_as_paranoid
  audited

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  include Bootsy::Container
  mount_uploader :logo, PhotoUploader

  has_many :internal_users
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id"

  validates :name, presence: true

  def address
    @address
  end

  def address_attributes=(attributes)
    # Process the attributes hash
  end

  def self.jtrp
    Company.find_by(name: "Just the Right Piece")
  end

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}"
  end

  def maps_url(size="200x200")
    GeolocationService.new(self).static_map_url(size)
  end

  def directions_link
    GeolocationService.new(self).directions_link
  end

end
