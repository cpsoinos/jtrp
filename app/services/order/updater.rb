class Order::Updater

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def update
    update_amount
    retrieve_items
    retrieve_order_discounts
    retrieve_item_discounts
    apply_discounts
    mark_items_sold
    set_timestamps
  end

  private

  def remote_order
    @_remote_order ||= Clover::Order.find(order)
  end

  def set_timestamps
    order.update_attributes(
      created_at: format_time(remote_order.createdTime),
      updated_at: format_time(remote_order.modifiedTime)
    )
  end

  def format_time(time)
    nil unless time
    Time.at(time/1000)
  end

  def update_amount
    order.amount_cents = remote_order.total
    order.save
  end

  def retrieve_items
    line_items.each do |line_item|
      order.items << retrieve_local_item_from(line_item)
    end
  end

  def line_items
    @_line_items ||= remote_order.try(:lineItems).try(:elements)
    @_line_items ||= []
  end

  def retrieve_local_item_from(line_item)
    remote_id = line_item.try(:item).try(:id)
    remote_id ||= line_item.try(:lineItemRef).try(:id)
    Item.find_by(remote_id: remote_id)
  end

  def retrieve_order_discounts
    order_discounts.each do |attrs|
      Discount::Creator.new(order).create(attrs)
    end
  end

  def order_discounts
    @_order_discounts ||= remote_order.try(:discounts).try(:elements)
    @_order_discounts ||= []
  end

  def retrieve_item_discounts
    return unless items_discounted?
    item_discounts.each do |attrs|
      item = retrieve_local_item_from(attrs)
      Discount::Creator.new(item).create(attrs)
    end
  end

  def items_discounted?
    order.amount_cents != order.items.sum(:listing_price_cents)
  end

  def item_discounts
    @_item_discounts ||= Clover::Discount.find(order)
  end

  def apply_discounts
    order.discounts.map(&:apply)
    order.items.map { |item| item.discounts.map(&:apply) }
  end

  def mark_items_sold
    order.items.map do |item|
      next if item.sold? && item.sale_price_cents.present? && item.sold_at.present?
      ItemUpdater.new(item).update(sale_price_cents: item.listing_price_cents, sold_at: order.created_at)
    end
  end

end
