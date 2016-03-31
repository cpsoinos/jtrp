class Item < ActiveRecord::Base
  has_secure_token

  mount_uploaders :photos, PhotoUploader
  monetize :purchase_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :listing_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :sale_price_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  belongs_to :category

  validates :category, presence: true
  validates :name, presence: true

  def barcode
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'
    require 'barby/outputter/html_outputter'

    barcode = Barby::Code128B.new(token)
    Barby::HtmlOutputter.new(barcode).to_html
  end

end
