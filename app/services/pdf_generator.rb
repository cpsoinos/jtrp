class PdfGenerator

  attr_reader :object, :account

  def initialize(object)
    @object = object
    @account = @object.account
  end

  def render_pdf
    create_response
  end

  private

  def create_response
    DocRaptor::DocApi.new.create_doc(
      test:             (Rails.env == 'production' ? false : true),
      document_url:     object.object_url,
      name:             "#{account.full_name}_#{object.class.name}_#{object.id}.pdf",
      document_type:    "pdf",
      javascript:       true,
      prince_options: {
        media: "screen"
      }
    )
  end

end
