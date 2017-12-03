module Orders
  class Processor

    attr_reader :order, :discounts

    def initialize(order)
      @order = order
      @discounts = []
    end

    def process
      update_amount
      process_line_items
      apply_order_discounts
      retrieve_delivery_charge
      apply_delivery_charge
      set_timestamps
    end

    private

    def remote_object
      @_remote_object ||= order.remote_object
    end

    def set_timestamps
      order.update_attributes(
        created_at: remote_object.createdTime,
        updated_at: remote_object.modifiedTime
      )
    end

    def update_amount
      order.amount = remote_object.total
      order.save
    end

    def process_line_items
      line_items.each do |line_item|
        item = Item.find_by(id: line_item.try(:item).try(:sku))
        next if item.nil?
        Items::Updater.new(item).update(order: order, sale_price: line_item.price, sold_at: line_item.orderClientCreatedTime)
        if line_item.discounts
          remote_discount = line_item.discounts.first
          discount = Discounts::Creator.new(item).create(remote_discount)
          Discounts::Applier.new(discount).execute
        end
      end
    end

    def line_items
      @_line_items ||= remote_object.lineItems
    end

    def apply_order_discounts
      if remote_object.try(:discounts)
        remote_object.discounts.each do |remote_discount|
          discount = Discounts::Creator.new(order).create(remote_discount)
          Discounts::Applier.new(discount).execute
        end
      end
    end

    def retrieve_delivery_charge
      @_retrieve_delivery_charge ||= line_items.detect { |i| i.try(:name) == 'Delivery Charge' }
    end

    def apply_delivery_charge
      return if retrieve_delivery_charge.nil?
      return unless retrieve_delivery_charge.try(:price).is_a?(Integer)
      order.update(delivery_charge: retrieve_delivery_charge.price)
    end

  end
end
