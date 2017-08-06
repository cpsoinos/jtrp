class Account < ActiveRecord::Base
  include PublicActivity::Common
  include AccountStateMachine
  include Filterable
  include PgSearch

  acts_as_paranoid
  audited

  extend FriendlyId
  friendly_id :short_name, use: [:slugged, :finders, :history]

  self.inheritance_column = :type
  def self.types
    %w(OwnerAccount ClientAccount)
  end

  multisearchable against: [:full_name, :status]

  has_many :clients
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id", touch: true
  has_many :jobs, dependent: :destroy
  has_many :proposals, through: :jobs
  has_many :items, through: :proposals
  has_many :agreements, through: :proposals
  has_many :statements
  belongs_to :created_by, class_name: "InternalUser", foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "InternalUser", foreign_key: "updated_by_id"
  has_many :letters, through: :agreements

  validates :status, presence: true
  validates :type, presence: true

  scope :status, -> (status) { where(status: status) }

  scope :owner, -> { where(type: "Owner") }
  scope :customer, -> { where(type: "Customer") }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  alias :client :primary_contact
  delegate :full_address, to: :primary_contact
  delegate :first_name, to: :primary_contact
  delegate :last_name, to: :primary_contact
  delegate :address_1, to: :primary_contact
  delegate :address_2, to: :primary_contact
  delegate :city, to: :primary_contact
  delegate :state, to: :primary_contact
  delegate :zip, to: :primary_contact
  delegate :phone, to: :primary_contact
  delegate :phone_ext, to: :primary_contact
  delegate :email, to: :primary_contact

  def self.yard_sale
    Account.find_by(company_name: 'Yard Sale')
  end

  def self.estate_sale
    Account.find_by(company_name: 'Estate Sale')
  end

  def full_name
    Rails.cache.fetch("#{cache_key}/full_name") do
      if company_name.present?
        company_name
      elsif primary_contact.present?
        primary_contact.full_name
      else
        "No Name Provided"
      end
    end
  end

  def inverse_full_name
    Rails.cache.fetch("#{cache_key}/inverse_full_name") do
      if company_name.present?
        company_name
      elsif primary_contact.present?
        primary_contact.inverse_full_name
      else
        "No Name Provided"
      end
    end
  end

  def short_name
    if company_name.present?
      company_name
    elsif primary_contact.present?
      primary_contact.last_name
    else
      "No Name Provided"
    end
  end

  def avatar
    if primary_contact.present? && primary_contact.avatar.present?
      primary_contact.avatar_url(client_hints: true, quality: "auto", fetch_format: :auto, dpr: "auto")
    else
      ActionController::Base.helpers.asset_path("thumb_default_avatar.png")
    end
  end

  def self.default_url
    ActionController::Base.helpers.asset_path("thumb_No_Image_Available.png")
  end

  def yard_sale?
    company_name == "Yard Sale"
  end

  def estate_sale?
    company_name == "Estate Sale"
  end

  def consignment_account?
    Rails.cache.fetch("#{cache_key}/consignment?") do
      agreements.by_type('consign').present?
    end
  end

  def last_item_number
    if items.present?
      items.pluck(:account_item_number).compact.sort.last || 0
    else
      0
    end
  end

  def items_count
    Rails.cache.fetch(cache_key) do
      proposals.sum(:items_count)
    end
  end

  private

  def deactivate_items
    items.each do |item|
      next if item.owned?
      item.mark_inactive
    end
  end

end

####################################
# single table inheritance classes #
####################################

class OwnerAccount < Account

  def self.model_name
    Account.model_name
  end

  def items
    Item.jtrp
  end

end

class ClientAccount < Account
  def self.model_name
    Account.model_name
  end
end
