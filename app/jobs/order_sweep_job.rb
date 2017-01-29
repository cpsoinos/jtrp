require 'active_job/traffic_control'

class OrderSweepJob
  include Sidekiq::Worker
  include ActiveJob::TrafficControl::Throttle

  sidekiq_options queue: 'maintenance'

  throttle threshold: 5, period: 1.second

  def perform(order)
    order.process_webhook
    order.items.update_all(sold_at: order.created_at)
  end

end
