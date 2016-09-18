class Discount < ActiveRecord::Base
  belongs_to :item
  belongs_to :order

  monetize :amount_cents, allow_nil: true, numericality: {
    less_than_or_equal_to: 0
  }

  def apply_to_item
    # this will handle marking as sold in addition to applying discount
    ItemUpdater.new(item).update(sale_price_cents: (item.listing_price_cents + amount_cents), sold_at: order.updated_at)
  end

end
