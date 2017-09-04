class TransactionalEmailJob < ApplicationJob
  queue_as :default

  def perform(object, user, recipient, email_type, options={})
    TransactionalEmailer.new(object, user, email_type).send(recipient, options)
  end

end
