class Order::Updater

  attr_reader :order, :discounts

  def initialize(order)
    @order = order
    @discounts = []
  end

  def update
    update_amount
    retrieve_items
    retrieve_discounts
    apply_discounts
    set_timestamps
    mark_items_sold
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
      item = LineItems::Retriever.new(line_item).execute
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

  def retrieve_discounts
    @_retrieve_discounts ||= Discounts::Retriever.new(order).execute
  end

  def apply_discounts
    retrieve_discounts.each do |discount|
      Discounts::Applier.new(discount).execute
    end
  end

  def mark_items_sold
    order.reload.items.each do |item|
      Item::Updater.new(item).update(sold_at: order.created_at)
    end
  end

end
