class Letter < ActiveRecord::Base
  belongs_to :account
  mount_uploader :pdf, ScannedAgreementUploader

  after_create :save_as_pdf

  private

  def save_as_pdf
    PdfGenerator.new(self).render_pdf #fix this
  end

end
