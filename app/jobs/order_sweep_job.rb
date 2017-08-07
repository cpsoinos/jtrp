require 'active_job/traffic_control'

class OrderSweepJob < ApplicationJob
  include ActiveJob::TrafficControl::Throttle

  queue_as :maintenance

  throttle threshold: 2, period: 1.second unless Rails.env.test?

  rescue_from(Clover::CloverError) do
    retry_job wait: 5.minutes, queue: :low
  end

  def perform(options)
    order = Order.find(options[:order_id])
    order.process_webhook
  end

end
