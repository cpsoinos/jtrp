class LetterSenderJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: false, backtrace: true

  def perform(letter)
    LetterSender.new(letter).send_letter
  end

end
