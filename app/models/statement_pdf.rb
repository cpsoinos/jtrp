class StatementPdf < ActiveRecord::Base
  audited associated_with: :statement
  include Streamable

  belongs_to :statement, touch: true
  mount_uploader :pdf, ScannedAgreementUploader

  validates :statement, presence: true
  validates :pdf, presence: true

  def object_url
    pdf.file.public_url
  end

end
