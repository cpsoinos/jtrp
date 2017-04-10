namespace :pdfs do

  task :migrate_to_cloudinary => :environment do

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
