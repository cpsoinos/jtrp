class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

  has_many :proposals

  validates :email, presence: true, uniqueness: true
  validates :status, presence: true

  scope :client, -> { where(role: "client") }
  scope :agent, -> { where(role: "agent") }
  scope :internal, -> { where(role: "internal") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  def internal?
    role == "internal" || role == "admin"
  end

  def client?
    role == "client"
  end

  def agent?
    role == "agent"
  end

  def active?
    status == "active"
  end

  def inactive?
    status == "inactive"
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
