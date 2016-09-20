class Discount < ActiveRecord::Base
  belongs_to :item
  belongs_to :order

  monetize :amount_cents, allow_nil: true, numericality: {
    less_than_or_equal_to: 0
  }

  def apply_to_item
    return if applied?
    # this will handle marking as sold in addition to applying discount
    ItemUpdater.new(item).update(sale_price_cents: (item.listing_price_cents + calculate_discount), sold_at: order.updated_at)
    self.applied = true
    self.save
  end

  def calculate_discount
    if percentage
      item.listing_price_cents * (percentage.to_f / 100) * -1
    else
      amount_cents
    end
  end

end