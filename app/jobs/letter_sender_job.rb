class LetterSenderJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    letter = Letter.find(options[:letter_id])
    Letter::Sender.new(letter).send_letter
  end

end
