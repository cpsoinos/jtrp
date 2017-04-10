class AddPdfToAgreementsAndStatements < ActiveRecord::Migration
  def change
    add_column :agreements, :pdf, :string
    add_column :statements, :pdf, :string

    Agreement.reset_column_information
    Statement.reset_column_information

    ScannedAgreement.all.each do |scanned_agreement|
      begin
        agreement = scanned_agreement.agreement
        next if agreement.nil?
        agreement.remote_pdf_url = scanned_agreement.scan_url
        agreement.save
        PdfGenerator.new(agreement).send(:save_page_count)
      rescue Cloudinary::CarrierWave::UploadError
        next
      end
    end

    StatementPdf.all.each do |statement_pdf|
      begin
        statement = statement_pdf.statement
        next if statement.nil?
        statement.remote_pdf_url = statement_pdf.pdf_url
        statement.save
        PdfGenerator.new(statement).send(:save_page_count)
      rescue Cloudinary::CarrierWave::UploadError
        next
      end
    end

  end
end
