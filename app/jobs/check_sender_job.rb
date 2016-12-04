class CheckSenderJob < ActiveJob::Base
  queue_as :default

  def perform(statement)
    CheckSender.new(statement).send_check
  end

end
