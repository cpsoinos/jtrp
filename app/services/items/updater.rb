module Items
  class Updater

    attr_reader :item, :attrs

    def initialize(item)
      @item = item
    end

    def update(attrs)
      @attrs = attrs
      process_photos
      format_date
      if item.update(attrs)
        process_sale
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
      return unless item.sale_price.present? && item.sold_at.present?
      item.mark_sold unless item.sold?
    end

    def sync_inventory
      return if item.potential?
      InventorySyncJob.perform_later(item)
    end

    def format_date
      if attrs[:sold_at].present?
        if attrs[:sold_at].is_a?(String)
          attrs[:sold_at] = DateTime.strptime(attrs[:sold_at], '%m/%d/%Y')
        end
        if attrs[:sold_at] < 2000.years.ago
          attrs[:sold_at] = 2000.years.since(attrs[:sold_at])
        end
      end
      if attrs[:acquired_at].present?
        if attrs[:acquired_at].is_a?(String)
          attrs[:acquired_at] = DateTime.strptime(attrs[:acquired_at], '%m/%d/%Y')
        end
        if attrs[:acquired_at] < 2000.years.ago
          attrs[:acquired_at] = 2000.years.since(attrs[:sold_at])
        end
      end
    end

  end
end
