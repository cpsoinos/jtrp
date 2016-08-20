class TransactionalEmailJob < ActiveJob::Base
  queue_as :default

  def perform(proposal, user, note)
    TransactionalEmailer.new(proposal, user).send_to_client(note)
  end

end
