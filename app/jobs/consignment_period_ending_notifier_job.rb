class ConsignmentPeriodEndingNotifierJob < ApplicationJob
  queue_as :default

  attr_reader :agreement, :category

  def perform(agreement, category)
    @agreement = agreement
    @category = category
    execute
  end

  private

  def execute
    build_letter
    deliver_mail
    deliver_email
  end

  def build_letter
    @letter = Letter::Creator.new(agreement).create_letter(category)
    @letter.save_as_pdf
  end

  def deliver_mail
    Letter::Sender.new(@letter).send_letter
  end

  def deliver_email
    if category == 'agreement_pending_expiration'
      Notifier.send_agreement_pending_expiration(@letter).deliver_later
    elsif category == 'agreement_expired'
      Notifier.send_agreement_expired(@letter).deliver_later
    end
  end

end
