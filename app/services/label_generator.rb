require "open-uri"

class LabelGenerator

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def generate
    Prawn::Labels.render(@items, type: "Burris8UP") do |pdf, item|
      pdf.font_families.update(
        "Roboto" => {
          bold:        "app/assets/fonts/RobotoSlab-Bold.ttf",
          normal:      "app/assets/fonts/RobotoSlab-Regular.ttf"
        }
      )
      pdf.font "Roboto"
      pdf.image logo
      pdf.text_box item.description.titleize, at: [55, 175], height: 50, width: 240, align: :center
      pdf.text_box ActionController::Base.helpers.humanized_money_with_symbol(item.listing_price), at: [85, 125], height: 50, width: 187, size: 18, align: :center
      pdf.text_box "SKU:\nItem No.:\n#{item.consigned? ? item.account.client.last_name : 'JTRP No.:'}", at: [0, 85], height: 75, width: 80, size: 10
      pdf.text_box "#{item.id}\n#{item.account_item_number}\n#{item.owned? ? item.jtrp_number : ''}", at: [0, 85], height: 75, width: 80, size: 10, align: :right
      pdf.image item.barcode, at: [85, 100]
    end
  end

  private

  def logo
    @_logo ||= open(Company.jtrp.logo.url(quality: "auto", fetch_format: :auto, width: 50, crop: "scale"))
  end

end
