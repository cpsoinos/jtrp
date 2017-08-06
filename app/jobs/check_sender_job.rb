class CheckSenderJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    statement = Statement.find(options[:statement_id])
    Checks::Sender.new(statement).send_check
  end

end
