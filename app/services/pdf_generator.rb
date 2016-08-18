class PdfGenerator
  include Rails.application.routes.url_helpers

  attr_reader :agreement, :proposal, :job, :account

  def initialize(agreement)
    @agreement = agreement
    # @proposal = agreement.proposal
    # @job = @proposal.job
    # @account = @job.account
  end

  def render_pdf
    create_response
  end

  private

  def create_response
    DocRaptor::DocApi.new.create_doc(
      test:             true,                                         # test documents are free but watermarked
      document_url:     document_url,
      name:             "#{account.full_name}_#{agreement.agreement_type}.pdf",                         # help you find a document later
      document_type:    "pdf",                                        # pdf or xls or xlsx
      javascript:       true,                                       # enable JavaScript processing
      prince_options: {
        media: "screen",                                            # use screen styles instead of print styles
        # baseurl: "http://hello.com",                                # pretend URL when using document_content
      },
    )
  end

  def document_url
    Rails.application.routes.url_helpers(agreement_url(agreement), host: ENV['HOST'])
  end

end
