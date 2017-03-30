module Discounts
  class Applier

    attr_reader :discount, :discountable

    def initialize(discount)
      @discount = discount
      @discountable = discount.discountable
    end

    def execute
      apply_discount
      discount.applied = true
      discount.save
      discount
    end

    private

    def apply_discount
      if is_order?
        apply_to_order
      else
        apply_to_item(discountable)
      end
    end

    def apply_to_order
      discountable.items.each do |item|
        apply_to_item(item)
      end
    end

    def apply_to_item(item)
      item.sale_price_cents = discount_amount(item)
      item.save
    end

    def discount_amount(item)
      item.listing_price_cents - calculate_discount(item)
    end

    def calculate_discount(item)
      amount = begin
        if !discount.percentage.zero?
          item.listing_price_cents * discount.percentage
        else
          (discount.amount_cents * -1)
        end
      end

      distribute_amongst_items(amount)
    end

    def distribute_amongst_items(amount)
      return amount unless is_order? && discount.percentage.zero?
      amount / discountable.items.count
    end

    def is_order
      @_is_order ||= discountable.is_a?(Order)
    end
    alias is_order? is_order

  end
end
