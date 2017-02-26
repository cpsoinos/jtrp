require 'active_job/traffic_control'

class OrderSweepJob < ActiveJob::Base
  include ActiveJob::TrafficControl::Throttle

  queue_as :maintenance

  throttle threshold: 2, period: 1.second

  rescue_from(Clover::CloverError) do
    retry_job wait: 5.minutes, queue: :low
  end

  def perform(order)
    order.process_webhook
  end

end
