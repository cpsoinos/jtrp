class ConsignmentPeriodEndingNotifierJob < ActiveJob::Base
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
    @letter = LetterCreator.new(agreement).create_letter(category)
    @letter.save_as_pdf
  end

  def deliver_mail
    LetterSender.new(@letter).send_letter
  end

  def deliver_email
    TransactionalEmailJob.perform_later(@letter, Company.jtrp.primary_contact, @agreement.account.primary_contact, category)
  end

end
