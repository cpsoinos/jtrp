class Item < ActiveRecord::Base
  include Filterable

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos
  belongs_to :category
  belongs_to :proposal

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
  scope :for_sale, -> { where(status: "active", client_intention: "sell") }
  scope :consigned, -> { where(status: "active", client_intention: "consign") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :sold

    after_transition potential: :active, do: [:set_listed_at]
    after_transition active: :sold, do: [:mark_agreement_inactive, :set_sold_at]

    event :mark_active do
      transition potential: :active, if: lambda { |item| item.meets_requirements_active? }
    end

    event :mark_sold do
      transition active: :sold, if: lambda { |item| item.meets_requirements_sold? }
    end
  end

  def initial_photos
    photos.initial
  end

  def listing_photos
    photos.listing
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
    agreement.mark_inactive
  end

  def meets_requirements_active?
    agreement.reload.present? &&
    agreement.active?
  end

  def meets_requirements_sold?
    meets_requirements_active?
  end

  def set_listed_at
    self.listed_at = DateTime.now
    self.save
  end

  def set_sold_at
    self.sold_at = DateTime.now
    self.save
  end

  def owned?
    active? && client_intention == "sell"
  end

  def consigned?
    active? && client_intention == "consign"
  end

  def offer_chosen?
    potential? && (!will_consign.nil? || !will_purchase.nil?)
  end

  def ownership_type
    if owned?
      "owned".titleize
    elsif consigned?
      "consigned".titleize
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
    elsif client_intention == "move"
      "primary-darker"
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
      "secondary-lighter"
    elsif type == "donate"
      "secondar-darker"
    elsif type == "move"
      "primary-darker"
    else
      "primary-lighter"
    end
  end

end
