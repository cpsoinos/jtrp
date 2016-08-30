class Item < ActiveRecord::Base
  include Filterable
  include PgSearch

  multisearchable against: [:description, :status, :client_intention, :will_consign, :will_purchase]
  paginates_per 10

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos
  belongs_to :category
  belongs_to :proposal
  belongs_to :order
  has_many :children, class_name: "Item", foreign_key: "parent_item_id"
  belongs_to :parent_item, class_name: "Item", foreign_key: "parent_item_id"

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

  delegate :job, :account, to: :proposal

  validates :description, :proposal, presence: true

  scope :status, -> (status) { where(status: status) }
  scope :type, -> (type) { where(client_intention: type) }

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :sold, -> { where(status: "sold") }
  scope :unsold, -> { where.not(status: "sold") }
  scope :owned, -> { where(status: "active", client_intention: "sell") }
  scope :consigned, -> { where(status: "active", client_intention: "consign") }
  scope :for_sale, -> { active.where(client_intention: ['sell', 'consign']) }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :sold
    state :inactive

    after_transition potential: :active, do: [:set_listed_at, :sync_inventory]
    after_transition active: :sold, do: [:mark_agreement_inactive, :set_sold_at, :sync_inventory]
    after_transition any => :inactive, do: :sync_inventory

    event :mark_active do
      transition potential: :active, if: lambda { |item| item.meets_requirements_active? }
    end

    event :mark_sold do
      transition active: :sold, if: lambda { |item| item.meets_requirements_sold? }
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

  def featured_photos
    photos.featured
  end

  def featured_photo_url(format=nil)
    Rails.cache.fetch("#{cache_key}/featured_photo_url/format_#{format}", expires_in: 2.weeks) do
      featured_photo ||= featured_photos.first || listing_photos.first || initial_photos.first
      if featured_photo.present?
        featured_photo.photo_url(format, quality: "auto", fetch_format: :auto, effect: :improve)
      else
        "thumb_No_Image_Available.png"
      end
    end
  end

  def agreement
    if proposal
      proposal.agreements.find_by(agreement_type: client_intention)
    end
  end

  def barcode(pdf=false)
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/cairo_outputter'

    barcode = Barby::Code128B.new(token)
    barcode = Barby::CairoOutputter.new(barcode).to_svg(width: '160px')
    if pdf
      barcode = "data:image/svg+xml;base64,#{Base64.encode64(barcode)}"
    end
    barcode
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

end
