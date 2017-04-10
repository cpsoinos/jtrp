class PdfGenerator

  attr_reader :object, :account

  def initialize(object)
    @object = object
    @account = object.account
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
        document_url:     "#{object.object_url}&print=true",
        name:             "#{account.full_name}_#{object.class.name}_#{object.id}.pdf",
        document_type:    "pdf",
        javascript:       true
      )

      loop do
        status_response = $docraptor.get_async_doc_status(create_response.status_id)
        case status_response.status
        when "completed"
          doc_response = $docraptor.get_async_doc(status_response.download_id)
          file = StringIO.new(doc_response)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = "#{account.full_name}_#{object.class.name}_#{object.id}.pdf"
          file.content_type = "application/pdf"
          save_file(file)
          break
        when "failed"
          raise DocRaptor::ApiError.new(status_response)
          break
        else
          sleep 1
        end
      end

    rescue DocRaptor::ApiError => error
      Airbrake.notify(error, { object_type: object.class.name, object_id: object.id })
    end
  end

  def save_file(file)
    object.pdf = file
    object.save
    save_page_count
  end

  def save_page_count
    resp = Cloudinary::Api.resource(object.pdf.file.public_id, pages: true)
    page_count = resp["pages"]
    object.pdf_pages = page_count
    object.save
  end

end
