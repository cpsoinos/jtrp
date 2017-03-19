class PaymentProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(payment)
    Payment::Processor.new(payment).process
  end

end
