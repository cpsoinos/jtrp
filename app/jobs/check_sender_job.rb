class CheckSenderJob < ActiveJob::Base
  queue_as :default

  def perform(statement)
    Check::Sender.new(statement).send_check
  end

end
