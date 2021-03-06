class Letter < ApplicationRecord
  include PublicActivity::Common

  acts_as_paranoid
  audited associated_with: :agreement
  has_secure_token

  belongs_to :agreement, optional: true
  has_one :account, through: :agreement
  mount_uploader :pdf, PdfUploader

  validates :category, presence: true

  scope :by_category, -> (category) { where(category: category) }

  def short_name
    "#{account.short_name}_#{category}_letter"
  end

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
    PdfGenerator.new(self).render_pdf
  end

  def deliver_to_client
    expire_items
    deliver_email
    deliver_letter
  end

  def deliver_email
    if expiration_notice?
      Notifier.send_agreement_expired(self).deliver_later
    elsif expiration_pending_notice?
      Notifier.send_agreement_pending_expiration(self).deliver_later
    end
  end

  def deliver_letter
    LetterSenderJob.perform_later(letter_id: id)
  end

  def expire_items
    return unless expiration_notice?
    agreement.expire
  end

  def pending_deadline
    10.days.since(self.created_at.in_time_zone('Eastern Time (US & Canada)')).strftime("%B %e")
  end

  def hard_deadline
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%B %e")
  end

  def humanized_category
    return unless category
    category.gsub("_", " ").titleize
  end

end
