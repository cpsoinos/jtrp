class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:clover]

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

  self.inheritance_column = :role
  def self.roles
    %w(Admin InternalUser Client Guest)
  end

  mount_uploader :avatar, AvatarUploader

  has_many :proposals
  has_many :purchase_orders
  has_many :items, foreign_key: "client_id", class_name: "Item"

  validates :email, presence: true, uniqueness: true
  validates :status, presence: true

  scope :client, -> { where(role: "Client") }
  scope :internal, -> { where(role: "InternalUser") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  def self.from_omniauth(auth)
    oauth_user = where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split(" ").first   # assuming the user model has a name
      user.last_name = auth.info.name.split(" ").last   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
    end
    oauth_user.provider = auth.provider
    oauth_user.uid = auth.uid
    oauth_user.clover_token = auth.credentials.token
    oauth_user.save
    oauth_user
  end

  def internal?
    role == "InternalUser" || role == "Admin"
  end

  def client?
    role == "Client"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}"
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

end

class Admin < User; end
class Guest < User; end
