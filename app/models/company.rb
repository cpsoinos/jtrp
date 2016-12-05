class Company < ActiveRecord::Base
  acts_as_paranoid
  audited

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  include Bootsy::Container
  mount_uploader :logo, PhotoUploader
  mount_uploader :secondary_logo, PhotoUploader

  has_many :internal_users
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id"

  validates :name, presence: true

  def self.jtrp
    Company.find_by(name: "Just the Right Piece")
  end

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}"
  end

end
