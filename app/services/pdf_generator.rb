class PdfGenerator

  attr_reader :object, :account

  def initialize(object)
    @object = object
    @account = @object.account
  end

  def render_pdf
    create_async_response
  end

  private

  def create_response
    DocRaptor::DocApi.new.create_doc(
      test:             (Rails.env == 'production' ? false : true),
      document_url:     object.object_url,
      name:             "#{account.full_name}_#{object.class.name}_#{object.id}.pdf",
      document_type:    "pdf",
      javascript:       true
    )
  end

  def create_async_response
    $docraptor = DocRaptor::DocApi.new

    begin

      create_response = $docraptor.create_async_doc(
        test:             (Rails.env == 'production' ? false : true),
        document_url:     "#{object.object_url}?print=true",
        name:             "#{account.full_name}_#{object.class.name}_#{object.id}.pdf",
        document_type:    "pdf",
        javascript:       true
      )

      loop do
        status_response = $docraptor.get_async_doc_status(create_response.status_id)
        puts "doc status: #{status_response.status}"
        case status_response.status
        when "completed"
          doc_response = $docraptor.get_async_doc(status_response.download_id)
          file = StringIO.new(doc_response)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = "#{account.full_name}_#{object.class.name}_#{object.id}.pdf"
          file.content_type = "application/pdf"
          object.create_scanned_agreement(agreement: object, scan: file) if object.is_a?(Agreement)
          object.create_statement_pdf(statement: object, pdf: file) if object.is_a?(Statement)
          puts "Wrote PDF to /tmp/#{account.full_name}_#{object.class.name}_#{object.id}.pdf"
          break
        when "failed"
          puts "FAILED"
          puts status_response
          break
        else
          sleep 1
        end
      end

  end

end
