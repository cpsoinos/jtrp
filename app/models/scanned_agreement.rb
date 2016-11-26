class ScannedAgreement < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :agreement

  belongs_to :agreement, touch: true
  mount_uploader :scan, ScannedAgreementUploader

  validates :agreement, presence: true
  validates :scan, presence: true

  after_create :mark_agreement_active

  def object_url
    scan.file.public_url
  end

  def deliver_to_client
    TransactionalEmailJob.perform_later(self, Company.jtrp.primary_contact, agreement.account.primary_contact, "agreement", nil)
  end

  private

  def mark_agreement_active
    agreement.client_agreed = true
    agreement.client_agreed_at = DateTime.now
    agreement.manager_agreed = true
    agreement.manager_agreed_at = DateTime.now
    agreement.save
    agreement.mark_active
  end

end
