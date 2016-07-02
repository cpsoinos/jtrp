class Order < ActiveRecord::Base
  has_many :items

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }

  def process_webhook(webhook)
    Clover::Order.find(self)
  end

end
