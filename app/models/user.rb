class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  acts_as_paranoid
  audited
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:clover, :facebook, :twitter, :instagram]

  extend FriendlyId
  friendly_id :email, use: [:slugged, :finders, :history]

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

  self.inheritance_column = :role
  def self.roles
    %w(Admin InternalUser Client Guest)
  end

  mount_uploader :avatar, AvatarUploader

  has_many :proposals
  has_many :purchase_orders
  has_many :items, foreign_key: "client_id", class_name: "Item"
  has_many :identities

  validates :email, presence: true, uniqueness: true
  validates :status, presence: true

  scope :client, -> { where(role: "Client") }
  scope :internal, -> { where(role: "InternalUser") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  after_create :assign_avatar

  # def self.find_for_oauth(auth)
  #   oauth_user = where(email: auth.info.email).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.first_name = auth.info.name.split(" ").first   # assuming the user model has a name
  #     user.last_name = auth.info.name.split(" ").last   # assuming the user model has a name
  #     user.avatar = auth.info.image # assuming the user model has an image
  #   end
  #   oauth_user.provider = auth.provider
  #   oauth_user.uid = auth.uid
  #   oauth_user.clover_token = auth.credentials.token
  #   oauth_user.save
  #   oauth_user
  # end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = if auth.provider == "facebook"
                            auth.info.email.present?
                          else
                            auth.info.email && (auth.info.verified || auth.info.verified_email)
                          end
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
          avatar: auth.info.image
        )
        # Skip confirmation for OAuth if confirmable
        # user.skip_confirmation!
        user.save!
      end
    else
      # Update the user's attributes from the new OAuth
      user.update_attributes({
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        avatar: auth.info.image
      })
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    identity.check_for_account(auth)
    user
  end

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
