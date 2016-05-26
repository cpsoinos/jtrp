class ItemUpdater

  attr_reader :item, :attrs

  def initialize(item)
    @item = item
  end

  def update(attrs)
    @attrs = attrs
    process_photos
    process_offer_type
    item.update(attrs)
    item.mark_sold if attrs[:sale_price]
    item
  end

  private

  def process_photos
    if attrs[:initial_photos]
      initial_photos = attrs.delete(:initial_photos)
      initial_photos.each do |photo|
        item.photos.create!(photo: photo, photo_type: "initial")
      end
    end
    if attrs[:listing_photos]
      listing_photos = attrs.delete(:listing_photos)
      listing_photos.each do |photo|
        item.photos.create!(photo: photo, photo_type: "listing")
      end
    end
  end

  def process_offer_type
    if attrs[:offer_type]
      offer_type = attrs[:offer_type]
      if offer_type == "purchase"
        item.listing_price_cents = nil
        item.minimum_sale_price_cents = nil
      elsif offer_type == "consign"
        item.purchase_price = nil
      end
    end
  end

end
