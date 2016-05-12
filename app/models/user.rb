class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

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
