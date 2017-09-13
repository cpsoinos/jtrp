class Item < ApplicationRecord
  include PublicActivity::Common
  include ItemStateMachine
  include Filterable
  include PgSearch
  extend FriendlyId

  def self.default_scope
    includes(:primary_photo).where(deleted_at: nil)
  end

  friendly_id :description, use: [:slugged, :finders, :history]
  acts_as_paranoid
  acts_as_taggable_on :tags
  audited associated_with: :proposal
  multisearchable against: [:id, :account_item_number, :description, :original_description, :category_name, :category_id, :account_name, :job_name]
  paginates_per 18
  has_secure_token

  has_many :photos, -> { order(position: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :photos
  has_one :primary_photo, -> { where(position: 1) }, class_name: "Photo"
  belongs_to :category, touch: true, optional: true
  belongs_to :proposal, counter_cache: true, touch: true, optional: true
  belongs_to :order, optional: true
  has_many :discounts, as: :discountable
  has_many :children, class_name: "Item", foreign_key: "parent_item_id"
  belongs_to :parent_item, class_name: "Item", foreign_key: "parent_item_id", touch: true, optional: true
  has_one :job, through: :proposal
  has_one :account, through: :job
  has_many :webhook_entries, as: :webhookable
  has_one :agreement_item
  has_one :agreement, through: :agreement_item
  has_one :statement_item
  has_one :statement, through: :statement_item

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

  after_validation :ensure_token_uniqueness
  after_save :recalculate_agreement_association, on: :update

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

  scope :discountable, -> (amount) do
    case amount
    when 10
      for_sale.tagged_with("#{amount}% Off", exclude: true).where(listed_at: 60.days.ago..30.days.ago)
    when 20
      for_sale.tagged_with("#{amount}% Off", exclude: true).where(listed_at: 90.days.ago..60.days.ago)
    when 30
      for_sale.tagged_with("#{amount}% Off", exclude: true).where(listed_at: 120.days.ago..90.days.ago)
    when 40
      for_sale.tagged_with("#{amount}% Off", exclude: true).where(listed_at: 150.days.ago..120.days.ago)
    when 50
      for_sale.tagged_with("#{amount}% Off", exclude: true).where("listed_at < ?", 150.days.ago)
    else
      Item.none
    end
  end

  scope :pending_expiration, -> {
    listed_at = Item.arel_table[:listed_at]
    tagged_with('expired', exclude: true).where(client_intention: 'consign', status: %w(active inactive), expired: false).where(listed_at.lt(80.days.ago))
   }
  scope :meets_requirements_expired, -> {
    listed_at = Item.arel_table[:listed_at]
    tagged_with('expired', exclude: true).where(client_intention: 'consign', status: %w(active inactive), expired: false).where(listed_at.lt(90.days.ago))
   }

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
    primary_photo || Photo.new
  end

  def featured_photo_url
    ActionController::Base.helpers.image_tag(featured_photo.photo_url(:small_thumb, fetch_format: :auto, quality: :auto), class: "img-rounded img-raised").html_safe
  end

  Item.monetized_attributes.keys.each do |attribute|
    define_method("humanized_#{attribute}") { ActionController::Base.helpers.humanized_money_with_symbol(send(attribute)) }
  end

  def account_link
    ActionController::Base.helpers.link_to(account.short_name, Rails.application.routes.url_helpers.account_path(account)).html_safe
  end

  def description_link
    ActionController::Base.helpers.link_to(description.titleize, Rails.application.routes.url_helpers.item_path(self)).html_safe
  end

  # def agreement
  #   Rails.cache.fetch("#{proposal.cache_key}/#{client_intention}_agreement") do
  #     if proposal
  #       proposal.agreements.find_by(agreement_type: client_intention)
  #     end
  #   end
  # end

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

  def meets_requirements_expired?
    client_intention == "consign"     &&
      listed_at.present?              &&
      status.in?(%w(active inactive)) &&
      !tag_list.include?("expired")   &&
      !expired?                       &&
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
    return if should_not_sync?
    InventorySyncJob.perform_later(item_id: self.id)
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
      agreement_item.destroy
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

  def should_not_sync?
    listing_price_cents.nil? ||
      "fee".in?(tag_list)
  end

  def recalculate_agreement_association
    if agreement && agreement.agreement_type != client_intention
      agreement_item.destroy
      self.agreement = proposal.agreements.find_or_create_by(agreement_type: client_intention)
    end
  end

end
