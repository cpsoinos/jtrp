class Item < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable_on :tags
  audited associated_with: :proposal

  extend FriendlyId
  friendly_id :description, use: [:slugged, :finders, :history]

  include Filterable
  include PgSearch

  multisearchable against: [:id, :account_item_number, :description, :original_description, :category_name, :category_id, :account_name, :job_name]
  paginates_per 18

  has_many :photos, -> { order(position: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :photos
  belongs_to :category, touch: true
  belongs_to :proposal, counter_cache: true, touch: true
  belongs_to :order
  has_many :discounts, as: :discountable
  has_many :children, class_name: "Item", foreign_key: "parent_item_id"
  belongs_to :parent_item, class_name: "Item", foreign_key: "parent_item_id", touch: true
  has_one :job, through: :proposal
  has_one :account, through: :job
  has_many :webhook_entries, as: :webhookable

  has_secure_token
  after_validation :ensure_token_uniqueness

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
  monetize :parts_cost_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :labor_cost_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  validates :description, :proposal, :client_intention, presence: true
  validates :remote_id, uniqueness: { message: "remote_id already taken" }, allow_nil: true
  validates :token, uniqueness: true, allow_nil: true

  scope :status, -> (status) { where(status: status) }
  scope :type, -> (type) do
    if type == 'expired'
      expired
    else
      where(client_intention: type)
    end
  end
  scope :by_id, -> (id_param) { where(id: id_param) }
  scope :by_category_id, -> (category_id_param) { where(category_id: category_id_param) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :sold, -> { where(status: "sold") }
  scope :unsold, -> { where.not(status: "sold") }
  scope :owned, -> { where(status: "active", client_intention: "sell").or(expired) }
  scope :jtrp, -> { where(status: ["active", "sold"], client_intention: "sell").or(expired) }
  scope :consigned, -> { where(status: "active", client_intention: "consign", expired: false) }
  scope :for_sale, -> { active.where(client_intention: ['sell', 'consign']).or(expired) }
  scope :expired, -> { where(client_intention: 'consign', expired: true) }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :sold
    state :inactive

    after_transition [:potential] => :active, do: [:set_listed_at, :sync_inventory]
    after_transition [:inactive] => :active, do: [:set_listed_at, :sync_inventory, :mark_agreement_active]
    after_transition [:active, :inactive] => :sold, do: [:mark_agreement_inactive, :set_sold_at, :sync_inventory]
    after_transition any => :inactive, do: :sync_inventory
    after_transition sold: :active, do: [:clear_sale_data, :mark_agreement_active]

    event :mark_active do
      transition [:potential] => :active, if: lambda { |item| item.meets_requirements_active? }
      transition [:inactive] => :active
    end

    event :mark_sold do
      transition [:active, :inactive] => :sold, if: lambda { |item| item.meets_requirements_sold? }
    end

    event :mark_inactive do
      transition any => :inactive
    end

    event :mark_not_sold do
      transition :sold => :active
    end

  end

  amoeba do
    include_association :category
    include_association :proposal
    include_association :photos
    prepend description: "Copy of "
    nullify :token
    nullify :remote_id
  end

  def initial_photos
    photos.initial
  end

  def listing_photos
    photos.listing
  end

  def featured_photo
    Rails.cache.fetch("#{cache_key}/featured_photo") do
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
    # agreement.mark_inactive unless import?
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
    !potential?
  end

  def meets_requirements_expired?
    active?       &&
      consigned?  &&
      (listed_at < consignment_term.days.ago)
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
    (active? || sold?) && client_intention == "consign" && !expired?
  end

  def offer_chosen?
    potential? && (!will_consign.nil? || !will_purchase.nil?)
  end

  def ownership_type
    if owned?
      "owned".titleize
    elsif expired?
      "expired".titleize
    elsif consigned?
      "consigned".titleize
    else
      status
    end
  end

  def parts_and_labor
    Money.new(parts_cost_cents) + Money.new(labor_cost_cents)
  end

  def amount_due_to_client
    return unless sold? && client_intention == "consign"
    Money.new((sale_price_cents * (100 - consignment_rate)) / 100) - parts_and_labor
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

  def category_name
    category.try(:name)
  end

  def account_name
    account.try(:full_name)
  end

  def job_name
    job.try(:name)
  end

  def mark_expired
    if meets_requirements_expired?
      self.tag_list += "expired"
      self.expired = true
      self.save
      mark_agreement_inactive
    end
  end

  def remote_attributes
    {
      name: description,
      price: listing_price_cents,
      sku: id,
      alternateName: token,
      code: token
    }.to_json
  end

  def remote_object
    return unless active? && remote_id.present?
    Clover::Inventory.find(self)
  end

  private

  def clear_sale_data
    cleared_attrs = {
      sold_at: nil,
      sale_price_cents: nil,
      order: nil
    }
    self.update(cleared_attrs)
  end

  def mark_agreement_active
    return if (import? || expired?)
    agreement.mark_active unless agreement.active?
  end

  def ensure_token_uniqueness
    if self.errors.full_messages.include?("Token has already been taken")
      self.regenerate_token
      ensure_token_uniqueness
    end
  end

end
