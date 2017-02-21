require 'active_job/traffic_control'

class OrderSweepJob < ActiveJob::Base
  include ActiveJob::TrafficControl::Throttle

  queue_as :maintenance

  throttle threshold: 5, period: 1.second

  def perform(order)
    order.process_webhook
  end

end
