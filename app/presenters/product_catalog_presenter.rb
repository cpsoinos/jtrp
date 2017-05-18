require 'csv'

class ProductCatalogPresenter

  def build_csv
    CSV.generate(headers: true) do |csv|
      csv << headers
      items.each do |item|
        csv << [item.id, "in stock", item.condition, item.description, item.featured_photo.photo_url, Rails.application.routes.url_helpers.item_url(item, host: ENV['HOST']), item.description.titleize, "#{item.listing_price.to_s} USD", item.remote_id, item.category.try(:name)]
      end
    end
  end

  private

  def headers
    %w(id availability condition description image_link link title price mpn product_type)
  end

  def items
    @_items ||= Item.includes(:category).joins(:photos).for_sale
  end

end
