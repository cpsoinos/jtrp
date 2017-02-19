class Discount < ActiveRecord::Base
  acts_as_paranoid
  # audited associated_with: :item

  belongs_to :discountable, polymorphic: true
  belongs_to :item
  belongs_to :order

  monetize :amount_cents, allow_nil: true, numericality: {
    less_than_or_equal_to: 0
  }

  # validates :discountable, presence: true

  def apply
    return if applied?
    if discountable_type == "Item"
      apply_to_item
    else
      apply_to_order
    end
    self.applied = true
    self.save
  end

  private

  def apply_to_item
    # this will handle marking as sold in addition to applying discount
    ItemUpdater.new(discountable).update(sale_price_cents: (discountable.listing_price_cents + calculate_discount(discountable)), sold_at: discountable.order.created_at)
    self.applied = true
    self.save
  end

  def apply_to_order
    discountable.items.each do |item|
      ItemUpdater.new(item).update(sale_price_cents: (item.listing_price_cents - calculate_discount(item)), sold_at: item.order.created_at)
    end
  end

  def calculate_discount(item)
    if percentage
      item.listing_price_cents * percentage
    else
      amount_cents
    end
  end

end
