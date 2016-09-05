class LabelGenerator

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def generate
    Prawn::Labels.render(@items, type: "Burris8UP") do |pdf, item|
      pdf.font_families.update(
        "Roboto" => {
          bold:        "#{Rails.root}/app/assets/fonts/RobotoSlab-Bold.ttf",
          normal:      "#{Rails.root}/app/assets/fonts/RobotoSlab-Regular.ttf"
        }
      )
      pdf.font "Roboto"
      pdf.image "app/assets/images/JTRPv2_color.PNG", width: 50, height: 50
      pdf.text_box item.description.titleize, at: [100, 175], height: 50, width: 190
      pdf.text_box ActionController::Base.helpers.humanized_money_with_symbol(item.listing_price), at: [155, 125], height: 50, width: 200, size: 18
      pdf.text_box "SKU:          #{item.id} \n Item No.:  #{item.account_item_number} \n JTRP No.: #{item.jtrp_number}", at: [0, 85], height: 75, width: 125, size: 10
      pdf.image item.barcode, at: [85, 100]
    end
  end

end
