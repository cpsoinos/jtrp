class OrderSweepJob < ActiveJob::Base
  queue_as :low

  throttle threshold: 5, period: 1.second

  def perform(order)
    order.process_webhook
    order.items.update_all(sold_at: order.created_at)
  end

end
