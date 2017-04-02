require 'active_job/traffic_control'

class PaymentProcessorJob < ActiveJob::Base
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 1, period: 5.seconds

  queue_as :default

  def perform(payment)
    Payments::Processor.new(payment).process
  end

end
