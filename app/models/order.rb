class Order < ActiveRecord::Base
  acts_as_paranoid
  audited

  has_many :items
  has_many :discounts

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
      remote_order.lineItems.try(:elements) || []
    else
      []
    end
  end

  def items_from_remote_id
    remote_item_ids ||= begin
      line_items.map do |element|
        next if element.name == "Manual Transaction"
        element.item.id
      end.compact
    end
    Item.where(remote_id: remote_item_ids)
  end

  def items_from_token
    tokens ||= begin
      line_items.map do |element|
        next if element.name == "Manual Transaction"
        element.try(:code)
      end.compact
    end
    Item.where(token: tokens)
  end

  def descriptions_from_line_items
    line_items.map do |element|
      next if element.name == "Manual Transaction"
      element.name
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
    self.items << items_from_remote_id
    # self.items << items_from_token # failsafe against items with prematurely removed remote ids
  end

  def remote_order_open?
    remote_order.try(:state) == "open"
  end

  def remote_order_locked?
    remote_order.try(:state) == "locked"
  end

  def mark_items_sold
    return unless items.present?
    # check for discount
    if amount_cents != items.sum(:listing_price_cents)
      retrieve_discounts
      self.reload.discounts.each do |discount|
        discount.apply_to_item
      end
    end
    items.map do |item|
      next if item.sold? && item.sale_price_cents.present? && item.sold_at.present?
      ItemUpdater.new(item).update(sale_price_cents: item.listing_price_cents, sold_at: self.created_at)
    end
  end

  def format_time(time)
    nil unless time
    Time.at(time/1000)
  end

  def retrieve_discounts
    remote_discounts ||= begin
      elements = Clover::Discount.find(self).try(:elements) || []
      elements.map { |e| e }
    end
    remote_discounts.map do |line_item|
      next unless line_item.respond_to?(:discounts)
      self.discounts.find_or_create_by!(
        remote_id: line_item.discounts.elements.first.id,
        item: discount_item(line_item),
        name: line_item.discounts.elements.first.name,
        amount_cents: line_item.discounts.elements.first.try(:amount),
        percentage: line_item.discounts.elements.first.try(:percentage)
      )
    end.compact
  end

  def discount_item(line_item)
    item = self.items.find_by(remote_id: line_item.item.id)
    item ||= self.items.find_by(description: line_item.name)
    item
  end

end
