class LetterSenderJob < ActiveJob::Base
  queue_as :default

  def perform(letter)
    LetterSender.new(letter).send_letter
  end

end
