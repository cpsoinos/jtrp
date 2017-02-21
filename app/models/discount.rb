class Discount < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :discountable, polymorphic: true

  monetize :amount_cents, allow_nil: true, numericality: {
    less_than_or_equal_to: 0
  }

  validates :discountable, presence: true
  validates :remote_id, uniqueness: { message: "remote_id already taken" }, allow_nil: true

  def apply
    return if applied?
    if discountable_type == "Item"
      apply_to_item(discountable)
    else
      apply_to_order
    end
    self.applied = true
    self.save
  end

  private

  def apply_to_item(item)
    ItemUpdater.new(item).update(sale_price_cents: (item.listing_price_cents - calculate_discount(item)), sold_at: item.order.created_at)
  end

  def apply_to_order
    discountable.items.each do |item|
      apply_to_item(item)
    end
  end

  def calculate_discount(item)
    if !percentage.zero?
      item.listing_price_cents * percentage
    else
      amount_cents * -1
    end
  end

end
