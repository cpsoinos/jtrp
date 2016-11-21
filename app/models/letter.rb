class Letter < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :agreement
  has_secure_token

  belongs_to :agreement
  has_one :account, through: :agreement
  mount_uploader :pdf, ScannedAgreementUploader

  def object_url
    Rails.application.routes.url_helpers.account_letter_url(account, self, token: token, host: ENV['HOST'])
  end

  def save_as_pdf
    PdfGenerator.new(self).render_pdf
  end

  def deliver_to_client
    deliver_email
    deliver_letter
  end

  def deliver_email
    TransactionalEmailJob.perform_later(self, Company.jtrp.primary_contact, account.primary_contact, "consignment_period_ending", nil)
  end

  def deliver_letter
    LetterSender.new(self).send_letter
  end

  def pending_deadline
    10.days.since(self.created_at).strftime("%B %d")
  end

  def hard_deadline
    self.created_at.strftime("%B %d")
  end

end
