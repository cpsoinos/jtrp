class CheckSenderJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false, backtrace: true

  def perform(statement)
    CheckSender.new(statement).send_check
  end

end
