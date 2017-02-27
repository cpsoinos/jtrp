class Order::Updater

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def update
    update_amount
    retrieve_items
    remove_cleared_items
    retrieve_order_discounts
    retrieve_item_discounts
    apply_discounts
    record_payment
    set_timestamps
  end

  private

  def remote_object
    @_remote_object ||= order.remote_object
  end

  def set_timestamps
    order.update_attributes(
      created_at: format_time(remote_object.createdTime),
      updated_at: format_time(remote_object.modifiedTime)
    )
  end

  def format_time(time)
    nil unless time
    Time.at(time/1000)
  end

  def update_amount
    order.amount_cents = remote_object.total
    order.save
  end

  def retrieve_items
    line_items.each do |line_item|
      item = retrieve_local_item_from(line_item)
      next if item.nil?
      order.items << item
      item.save
    end
    order.save
  end

  def line_items
    @_line_items ||= remote_object.try(:lineItems).try(:elements)
    @_line_items ||= []
  end

  def retrieve_local_item_from(line_item)
    item = find_item_by_remote_id(line_item)
    item ||= find_item_by_token(line_item)
  end

  def find_item_by_remote_id(line_item)
    remote_id = line_item.try(:item).try(:id)
    item = Item.find_by(remote_id: remote_id)
  end

  def find_item_by_token(line_item)
    token = line_item.try(:itemCode)
    token ||= line_item.try(:alternateName)
    Item.find_by(token: token)
  end

  def remove_cleared_items
    valid_tokens = line_items.map { |i| (i.try(:itemCode) || i.try(:alternateName)) }.compact
    order.items.each do |item|
      unless valid_tokens.include?(item.token)
        item.order = nil
        item.save
        order.reload
      end
    end
  end

  def retrieve_order_discounts
    order_discounts.each do |attrs|
      Discount::Creator.new(order).create(attrs)
    end
  end

  def order_discounts
    @_order_discounts ||= remote_object.try(:discounts).try(:elements)
    @_order_discounts ||= []
  end

  def retrieve_item_discounts
    item_discounts.each do |attrs|
      item = retrieve_local_item_from(attrs)
      Discount::Creator.new(item).create(attrs.discounts.elements.first)
    end
  end

  def items_discounted?
    order.amount_cents != order.items.sum(:listing_price_cents)
  end

  def item_discounts
    # only keep discounts applied to a specific item in Clover
    @_item_discounts ||= Clover::LineItem.find(order).reject { |d| d.try(:discounts).nil? }
  end

  def apply_discounts
    return unless payment_success?
    ApplyDiscountsJob.perform_later(order)
  end

  def remote_payments
    @_remote_payments ||= remote_object.try(:payments).try(:elements)
    @_remote_payments ||= []
  end

  def record_payment
    remote_payments.each do |attrs|
      Payment::Creator.new(order).create(attrs)
    end
  end

  def payment_success?
    return nil unless remote_payments.present?
    remote_payments.map(&:amount).sum == order.amount_cents
  end

end
