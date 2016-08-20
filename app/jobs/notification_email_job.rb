class NotificationEmailJob < ActiveJob::Base
  queue_as :default

  def perform(proposal, user, note)
    TransactionalEmailer.new(proposal, user).send_notification(note)
  end

end
