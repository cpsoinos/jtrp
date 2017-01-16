class OrderSweepJob < ActiveJob::Base
  include ActiveJob::TrafficControl::Throttle

  queue_as :low

  throttle threshold: 5, period: 1.second

  def perform(order)
    order.process_webhook
    order.items.update_all(sold_at: order.created_at)
  end

end
