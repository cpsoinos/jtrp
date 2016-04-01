class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

end
