class ScannedAgreement < ActiveRecord::Base
  belongs_to :agreement
  mount_uploader :scan, ScannedAgreementUploader

  validates :agreement, presence: true
  validates :scan, presence: true
end
