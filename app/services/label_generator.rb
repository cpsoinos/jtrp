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
      pdf.image "#{Rails.root}/app/assets/images/JTRPv2_color.PNG", width: 50, height: 50
      pdf.text_box item.description.titleize, at: [55, 175], height: 50, width: 240, align: :center
      pdf.text_box ActionController::Base.helpers.humanized_money_with_symbol(item.listing_price), at: [85, 125], height: 50, width: 187, size: 18, align: :center
      pdf.text_box "SKU:\nItem No.:\nJTRP No.:", at: [0, 85], height: 75, width: 80, size: 10
      pdf.text_box "#{item.id}\n#{item.account_item_number}\n#{item.jtrp_number}", at: [0, 85], height: 75, width: 80, size: 10, align: :right
      pdf.image item.barcode, at: [85, 100]
    end
  end

end
