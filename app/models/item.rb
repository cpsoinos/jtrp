class Item < ActiveRecord::Base
  include Filterable
  include PgSearch

  multisearchable against: [:description, :original_description, :status, :client_intention, :will_consign, :will_purchase]
  paginates_per 50

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos
  belongs_to :category
  belongs_to :proposal, counter_cache: true
  belongs_to :order
  has_many :discounts
  has_many :children, class_name: "Item", foreign_key: "parent_item_id"
  belongs_to :parent_item, class_name: "Item", foreign_key: "parent_item_id"
  has_one :job, through: :proposal
  has_one :account, through: :job

  before_create :record_original_description

  has_secure_token

  monetize :purchase_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :listing_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :minimum_sale_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :sale_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  validates :description, :proposal, presence: true

  scope :status, -> (status) { where(status: status) }
  scope :type, -> (type) { where(client_intention: type) }
  scope :by_id, -> (id_param) { where(id: id_param) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :sold, -> { where(status: "sold") }
  scope :unsold, -> { where.not(status: "sold") }
  scope :owned, -> { where(status: "active", client_intention: "sell") }
  scope :jtrp, -> { where(status: ["active", "sold"], client_intention: "sell") }
  scope :consigned, -> { where(status: "active", client_intention: "consign") }
  scope :for_sale, -> { active.where(client_intention: ['sell', 'consign']) }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :sold
    state :inactive

    after_transition [:potential, :inactive] => :active, do: [:set_listed_at, :sync_inventory]
    after_transition [:active, :inactive] => :sold, do: [:mark_agreement_inactive, :set_sold_at, :sync_inventory]
    after_transition any => :inactive, do: :sync_inventory

    event :mark_active do
      transition [:potential, :inactive] => :active, if: lambda { |item| item.meets_requirements_active? }
    end

    event :mark_sold do
      transition [:active, :inactive] => :sold, if: lambda { |item| item.meets_requirements_sold? }
    end

    event :mark_inactive do
      transition any => :inactive
    end
  end

  amoeba do
    include_association :category
    include_association :proposal
    include_association :photos
  end

  def initial_photos
    photos.initial
  end

  def listing_photos
    photos.listing
  end

  def featured_photo
    Rails.cache.fetch("#{cache_key}/featured_photo", expires_in: 2.weeks) do
      if listing_photos.present?
        listing_photos.first
      elsif initial_photos.present?
        initial_photos.first
      else
        Photo.default_photo
      end
    end
  end

  def agreement
    Rails.cache.fetch("#{proposal.cache_key}/#{client_intention}_agreement") do
      if proposal
        proposal.agreements.find_by(agreement_type: client_intention)
      end
    end
  end

  def barcode
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/cairo_outputter'

    barcode = Barby::Code128B.new(token)
    blob = Barby::CairoOutputter.new(barcode).to_png
    barcode

    file = Tempfile.new("item_#{id}_barcode.png")
    File.open(file, 'wb') { |f| f.write blob }
    file
  end

  def mark_agreement_inactive
    agreement.mark_inactive unless import?
  end

  def meets_requirements_active?
    if import?
      # bypass agreement requirement
      true
    else
      agreement.try(:active?)
    end
  end

  def meets_requirements_sold?
    meets_requirements_active?
  end

  def set_listed_at
    self.listed_at = DateTime.now
    self.save
  end

  def set_sold_at
    self.sold_at ||= DateTime.now
    self.save
  end

  def sync_inventory
    return if self.listing_price_cents.nil?
    InventorySyncJob.perform_later(self)
  end

  def owned?
    (active? || sold?) && client_intention == "sell"
  end

  def consigned?
    (active? || sold?) && client_intention == "consign"
  end

  def offer_chosen?
    potential? && (!will_consign.nil? || !will_purchase.nil?)
  end

  def ownership_type
    if owned?
      "owned".titleize
    elsif consigned?
      "consigned".titleize
    else
      status
    end
  end

  def panel_color
    if owned?
      "complement-primary"
    elsif consigned?
      "secondary-primary"
    elsif client_intention == "junk"
      "secondary-lighter"
    elsif client_intention == "donate"
      "secondary-darker"
    elsif offer_chosen?
      "complement-lighter"
    else
      "primary-lighter"
    end
  end

  def self.panel_color(type)
    if type == "sell"
      "complement-primary"
    elsif type == "consign"
      "secondary-primary"
    elsif type == "junk"
      "complement-darker"
    elsif type == "donate"
      "secondary-darker"
    else
      "primary-lighter"
    end
  end

  def task
    if active?
      if listing_price_cents.nil?
        { name: "add price", description: "needs a price added", task_field: :listing_price }
      elsif minimum_sale_price_cents.nil?
        { name: "add minimum sale price", description: "needs a minimum sale price added", task_field: :minimum_sale_price }
      end
    elsif sold?
      if sale_price_cents.nil?
        { name: "add sale price", description: "needs sale price recorded", task_field: :sale_price }
      end
    end
  end

  def build_child_item
    child = amoeba_dup
    child.parent_item = self
    child
  end

  def child?
    parent_item.present?
  end

  private

  def record_original_description
    self.original_description ||= self.description
  end

end
