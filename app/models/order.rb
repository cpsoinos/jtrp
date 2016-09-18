class Order < ActiveRecord::Base
  has_many :items

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }

  def process_webhook
    update_order
    add_items_to_order
    mark_items_sold if remote_order_locked?
  end

  def self.thirty_day_revenue
    Order.where(created_at: 30.days.ago..DateTime.now).sum(:amount_cents) / 100
  end

  private

  def remote_order
    @_remote_order ||= Clover::Order.find(self)
  end

  def line_items
    if remote_order.respond_to?(:lineItems)
      remote_order.lineItems.elements
    else
      []
    end
  end

  def remote_item_ids_from_line_items
    line_items.map do |element|
      next if element.name == "Manual Transaction"
      element.item.id
    end.compact
  end

  def update_order
    return unless remote_order
    self.amount_cents = remote_order.total
    self.created_at = format_time(remote_order.createdTime)
    self.updated_at = format_time(remote_order.modifiedTime)
    self.save
  end

  def add_items_to_order
    return unless (remote_order && line_items.present?)
    items = Item.where(remote_id: remote_item_ids_from_line_items)
    items.update_all(order_id: id)
  end

  def remote_order_open?
    remote_order.try(:state) == "open"
  end

  def remote_order_locked?
    remote_order.try(:state) == "locked"
  end

  def mark_items_sold
    items.map(&:mark_sold)
  end

  def format_time(time)
    nil unless time
    Time.at(time/1000)
  end

end
