require 'active_job/traffic_control'

class PaymentProcessorJob < ApplicationJob
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 1, period: 5.seconds

  queue_as :default

  def perform(options)
    payment = Payment.find(options[:payment_id])
    Payments::Processor.new(payment).process
  end

end
