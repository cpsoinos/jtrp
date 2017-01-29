class TransactionalEmailJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(object, user, recipient, email_type, options={})
    TransactionalEmailer.new(object, user, email_type).send(recipient, options)
  end

end
