class CheckSender
  include LobAddressable

  attr_reader :statement, :account

  def initialize(statement)
    @statement = statement
    @account = @statement.account
  end

  def send_check
    PdfGenerator.new(statement).render_pdf unless statement.statement_pdf.present?
    build_check
  end

  private

  def check
    @_check ||= statement.checks.first_or_create
  end

  def build_check
    resp = begin
      lob.checks.create(
        description: check.name,
        bank_account: ENV['LOB_BANK_KEY'],
        to: build_address(account.primary_contact),
        from: ENV['LOB_COMPANY_ADDRESS_KEY'],
        amount: statement.amount_due_to_client.to_f,
        memo: check.memo,
        logo: company.logo_url(width: 100, height: 100, crop: :pad),
        attachment: statement.statement_pdf.object_url
      )
    end
    save_response(resp)
  end

  def save_response(resp)
    check.remote_id                       = resp["id"]
    check.remote_url                      = resp["url"]
    check.carrier                         = resp["carrier"]
    check.amount                          = Money.new(resp["amount"] * 100)
    check.tracking_number                 = resp["tracking_number"]
    check.expected_delivery_date          = resp["expected_delivery_date"]
    check.check_number                    = resp["check_number"]
    check.data                            = resp
    check.save
    check.reload
    set_check_number(check)
    retrieve_check_images(check)
  end

  def company
    @_company ||= Company.jtrp
  end

  def retrieve_check_images(saved_check)
    CheckImageRetrieverJob.perform_later(saved_check)
  end

  def set_check_number(saved_check)
    statement.check_number = saved_check.check_number
    statement.save
  end

end
