class Item < ActiveRecord::Base
  has_secure_token
  include HasBarcode

  mount_uploaders :initial_photos, PhotoUploader
  mount_uploaders :listing_photos, PhotoUploader

  has_barcode :barcode,
    outputter: :svg,
    type: :code_39,
    value: Proc.new { |c| c.token }

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

  validates :name, presence: true

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :sold, -> { where(status: "sold") }

  # def barcode
  #   require 'barby'
  #   require 'barby/barcode/code_128'
  #   require 'barby/outputter/png_outputter'
  #   require 'barby/outputter/html_outputter'
  #
  #   barcode = Barby::Code128B.new(token)
  #   # Barby::HtmlOutputter.new(barcode).to_html
  #   blob = Barby::PngOutputter.new(barcode).to_png #Raw PNG data
  #   File.open('barcode.png', 'wb') { |f| f.write blob }
  # end

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
