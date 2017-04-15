class User < ActiveRecord::Base
  acts_as_paranoid
  audited
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:clover]

  extend FriendlyId
  friendly_id :email, use: [:slugged, :finders, :history]

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

  self.inheritance_column = :role
  def self.roles
    %w(Admin InternalUser Client Guest)
  end

  mount_uploader :avatar, AvatarUploader

  has_many :oauth_accounts

  validates :email, presence: true, uniqueness: true
  validates :status, presence: true

  scope :client, -> { where(role: "Client") }
  scope :internal, -> { where(role: "InternalUser") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  after_create :assign_avatar

  def internal?
    role == "InternalUser" || role == "Admin"
  end

  def admin?
    role == "Admin"
  end

  def client?
    role == "Client"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def inverse_full_name
    "#{last_name}, #{first_name}"
  end

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}"
  end

  def address_string
    GeolocationService.new(self).location_string
  end

  private

  def assign_avatar
    return if Rails.env.test?
    person = FullContact.person(email: email)
    if person.try(:photos).present?
      self.remote_avatar_url = person.photos.first.try(:url)
      self.save
    end
  rescue FullContact::NotFound
  rescue FullContact::Invalid
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

end

####################################
# single table inheritance classes #
####################################

class Admin < User; end
class Guest < User; end
