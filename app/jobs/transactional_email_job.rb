class TransactionalEmailJob < ActiveJob::Base
  queue_as :default

  def perform(object, user, recipient, email_type, note=nil)
    TransactionalEmailer.new(object, user, email_type).send(recipient, note)
  end

end
