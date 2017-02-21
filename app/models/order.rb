class Order < ActiveRecord::Base
  acts_as_paranoid
  audited

  has_many :items
  has_many :discounts, as: :discountable
  has_many :webhook_entries, as: :webhookable
  has_many :payments

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }

  validates :remote_id, uniqueness: true, allow_nil: true

  def process_webhook
    Order::Updater.new(self).update
  end

  def self.thirty_day_revenue
    Order.where(created_at: 30.days.ago..DateTime.now).sum(:amount_cents) / 100
  end

  def remote_object
    Clover::Order.find(self)
  end

end
