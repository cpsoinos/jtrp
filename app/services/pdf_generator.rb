class PdfGenerator

  attr_reader :agreement

  def initialize(agreement)
    @agreement = agreement
  end

  def render_pdf
    file_path = "#{Rails.root}/tmp/watermark_pdf.pdf"

    File.open(file_path, "wb") do |file|
      file.write(create_response)
    end
  end

  private

  def create_response
    DocRaptor::DocApi.new.create_doc(
      test:             true,                                         # test documents are free but watermarked
      # document_content: "<html><body>Hello World</body></html>",      # supply content directly
      document_url:   document_url, # or use a url
      name:             "docraptor-ruby.pdf",                         # help you find a document later
      document_type:    "pdf",                                        # pdf or xls or xlsx
      javascript:       true,                                       # enable JavaScript processing
      prince_options: {
        media: "screen",                                            # use screen styles instead of print styles
        # baseurl: "http://hello.com",                                # pretend URL when using document_content
      },
    )
  end

  def document_url
    Rails.application.routes.url_helpers(agreement_path(agreement.proposal.account, agreement.proposal.job, agreement.proposal, agreement))
  end

end
