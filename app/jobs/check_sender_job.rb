class CheckSenderJob < ApplicationJob
  queue_as :default

  def perform(statement)
    Checks::Sender.new(statement).send_check
  end

end
