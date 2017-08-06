class PaymentProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    payment = Payment.find(options[:payment_id])
    Payments::Processor.new(payment).process
  end

end
