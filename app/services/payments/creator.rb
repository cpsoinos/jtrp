module Payments
  class Creator

    attr_reader :order, :attrs

    def initialize(order)
      @order = order
    end

    def create(attrs)
      @attrs = attrs.to_hash
      attrs.symbolize_keys!
      create_payment
    end

    private

    def create_payment
      order.payments.find_or_create_by(payment_attrs)
    end

    def payment_attrs
      {
        remote_id: attrs[:id],
        amount_cents: attrs[:amount],
        tax_amount_cents: attrs[:taxAmount]
      }
    end

  end
end



