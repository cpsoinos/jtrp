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

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :sold, -> { where(status: "sold") }

  def barcode
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'
    require 'barby/outputter/html_outputter'
    require 'barby/outputter/cairo_outputter'

    barcode = Barby::Code128B.new(token)
    Barby::CairoOutputter.new(barcode).to_svg
  end

  def active?
    status == "active"
  end

  def potential?
    status == "potential"
  end

  def sold?
    status == "sold"
  end

end
