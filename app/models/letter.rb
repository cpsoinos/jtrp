class Letter < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :agreement
  has_secure_token

  belongs_to :agreement
  has_one :account, through: :agreement
  mount_uploader :pdf, ScannedAgreementUploader

  scope :by_category, -> (category) { where(category: category) }

  def expiration_notice?
    category == "agreement_expired"
  end

  def expiration_pending_notice?
    category == "agreement_pending_expiration"
  end

  def object_url
    Rails.application.routes.url_helpers.account_letter_url(account, self, token: token, host: ENV['HOST'])
  end

  def save_as_pdf
    return if pdf.present?
    PdfGenerator.new(self).render_pdf
  end

  def deliver_to_client
    expire_items
    deliver_email
    deliver_letter
  end

  def deliver_email
    TransactionalEmailJob.perform_later(self, Company.jtrp.primary_contact, account.primary_contact, category, {note: note})
  end

  def deliver_letter
    LetterSenderJob.perform_later(self)
  end

  def expire_items
    return unless expiration_notice?
    ItemExpirerJob.perform_later(agreement.items.pluck(:id))
  end

  def pending_deadline
    10.days.since(self.created_at.in_time_zone('Eastern Time (US & Canada)')).strftime("%B %e")
  end

  def hard_deadline
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%B %e")
  end

end
