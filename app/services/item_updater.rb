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
    item
  end

  private

  def process_photos
    process_initial_photos
    process_listing_photos
  end

  def process_initial_photos
    if attrs[:initial_photos].present?
      initial_photos = attrs.delete(:initial_photos)
      initial_photos.each do |photo|
        item.photos.create(photo: photo, photo_type: "initial")
      end
    end
  end

  def process_listing_photos
    if attrs[:listing_photos].present?
      listing_photos = attrs.delete(:listing_photos)
      listing_photos.each do |photo|
        item.photos.create!(photo: photo, photo_type: "listing")
      end
    end
  end

  def process_sale
    if (attrs[:sale_price].present? || attrs[:sale_price_cents].present?) && !item.sold?
      process_sold_at
      item.mark_sold!
    end
  end

  def sync_inventory
    return if item.potential?
    InventorySyncJob.perform_later(item)
  end

  def process_sold_at
    if attrs[:sold_at].present?
      format_date if attrs[:sold_at].is_a?(String)
    else
      attrs[:sold_at] = DateTime.now
    end
  end

  def format_date
    formatted_date = attrs[:sold_at].split("/")
    attrs[:sold_at] = "#{formatted_date[1]}/#{formatted_date[0]}/#{formatted_date[2]}"
  end

end
