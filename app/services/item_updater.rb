class ItemUpdater

  attr_reader :item, :attrs

  def initialize(item)
    @item = item
  end

  def update(attrs)
    @attrs = attrs
    process_photos
    process_sale
    if item.update(attrs)
      sync_inventory
    end
  end

  private

  def process_photos
    process_initial_photos
    process_listing_photos
  end

  def process_initial_photos
    if attrs[:initial_photos]
      initial_photos = attrs.delete(:initial_photos)
      initial_photos.each do |photo|
        item.photos.create!(photo: photo, photo_type: "initial")
      end
    end
  end

  def process_listing_photos
    if attrs[:listing_photos]
      listing_photos = attrs.delete(:listing_photos)
      listing_photos.each do |photo|
        item.photos.create!(photo: photo, photo_type: "listing")
      end
    end
  end

  def process_sale
    if attrs[:sale_price] && !item.sold?
      item.mark_sold!
    end
  end

  def sync_inventory
    InventorySyncJob.perform_later(item)
  end

end
