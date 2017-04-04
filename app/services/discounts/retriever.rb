module Discounts
  class Retriever

    attr_reader :order, :discounts

    def initialize(order)
      @order = order
      @discounts = []
    end

    def execute
      retrieve_order_discounts
      retrieve_item_discounts
      discounts
    end

    private

    def retrieve_order_discounts
      order_discounts.each do |attrs|
        discounts << Discounts::Creator.new(order).create(attrs)
      end
    end

    def order_discounts
      @_order_discounts ||= order.remote_object.try(:discounts).try(:elements)
      @_order_discounts ||= []
    end

    def retrieve_item_discounts
      line_items.map do |line_item|
        next unless line_item.respond_to?(:item)
        next unless line_item.respond_to?(:discounts)
        item = Item.find(line_item.item.sku)
        remote_discount = line_item.discounts.elements.first
        discounts << Discounts::Creator.new(item).create(remote_discount)
      end
    end

    def line_items
      @_line_items ||= order.remote_object.lineItems.elements
    end

  end
end
