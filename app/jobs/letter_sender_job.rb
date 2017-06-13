class LetterSenderJob < ApplicationJob
  queue_as :default

  def perform(letter)
    Letter::Sender.new(letter).send_letter
  end

end
