class Item < ActiveRecord::Base
  has_secure_token

  mount_uploaders :initial_photos, PhotoUploader
  mount_uploaders :listing_photos, PhotoUploader

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

  belongs_to :category
  belongs_to :proposal
  belongs_to :client, class_name: "User", foreign_key: "client_id"

  validates :name, presence: true
  validates :description, presence: true

  scope :potential, -> { where(state: "potential") }
  scope :active, -> { where(state: "active") }
  scope :sold, -> { where(state: "sold") }
  scope :unsold, -> { where.not(state: "sold") }

  state_machine :state, initial: :potential do
    state :potential
    state :active
    state :sold

    after_transition active: :sold, do: :check_agreement_state

    event :mark_active do
      transition potential: :active, if: lambda { |item| item.meets_requirements_active? }
    end

    event :mark_sold do
      transition active: :sold, if: lambda { |item| item.meets_requirements_sold? }
    end

  end

  def agreement
    proposal.agreements.find_by(agreement_type: client_intention)
  end

  def barcode(pdf=false)
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/cairo_outputter'

    barcode = Barby::Code128B.new(token)
    barcode = Barby::CairoOutputter.new(barcode).to_svg
    if pdf
      barcode = "data:image/svg+xml;base64,#{Base64.encode64(barcode)}"
    end
    barcode
  end

  def active?
    state == "active"
  end

  def potential?
    state == "potential"
  end

  def sold?
    state == "sold"
  end

  def check_agreement_state
    if agreement.items.active.empty?
      agreement.mark_inactive!
    end
  end

  def meets_requirements_active?
    agreement.present? &&
    agreement.active? &&
    proposal.present? &&
    proposal.active?
  end

  def meets_requirements_sold?
    meets_requirements_active?
  end

end
