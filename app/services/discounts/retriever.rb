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
      item_discounts.each do |line_item|
        item = find_item(line_item)
        discounts << Discounts::Creator.new(item).create(line_item.discounts.elements.first)
      end
    end

    def item_discounts
      # only keep discounts applied to a specific item in Clover
      @_item_discounts ||= Clover::LineItem.find(order).reject { |d| d.try(:discounts).nil? }
    end

    def find_item(line_item)
      LineItems::Retriever.new(line_item).execute
    end

  end
end
