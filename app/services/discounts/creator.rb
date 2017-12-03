module Discounts
  class Creator

    attr_reader :discountable, :attrs

    def initialize(discountable)
      @discountable = discountable
      @attrs = attrs
    end

    def create(attrs)
      @attrs = attrs
      create_discount
    end

    private

    def discount_attrs
      @_discount_attrs ||= {
        remote_id: attrs.id,
        percentage: format_percentage(attrs.try(:percentage)),
        amount: attrs.try(:amount),
        discountable: discountable,
        name: attrs.try(:name)
      }
    end

    def format_percentage(amt)
      amt.to_f / 100
    end

    def create_discount
      discount = Discount.find_or_initialize_by(remote_id: attrs.id)
      discount.assign_attributes(discount_attrs)
      discount.save
      discount
    end

  end
end
