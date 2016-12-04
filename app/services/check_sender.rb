class CheckSender

  attr_reader :statement, :account

  def initialize(statement)
    @statement = statement
    @account = @statement.account
  end

  def send_check
    PdfGenerator.new(statement).render_pdf
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
        to: {
          name: account.full_name,
          address_line1: account.address_1,
          address_line2: account.address_2,
          address_city: account.city,
          address_state: account.state,
          address_country: "US",
          address_zip: account.zip
        },
        from: ENV['LOB_COMPANY_ADDRESS_KEY'],
        amount: statement.amount_due_to_client.to_f,
        memo: check.memo,
        logo: File.new(Rails.root.join("assets", "images", "JTRPv2_color.png")),
        attachment: statement.statement_pdf.object_url
      )
    end
    save_response(resp)
  end

  def save_response(resp)
    check.remote_id                = resp[:id]
    check.remote_url               = resp[:url]
    check.carrier                  = resp[:carrier]
    check.amount                   = Money.new(resp[:amount])
    check.tracking_number          = resp[:tracking_number]
    check.expected_delivery_date   = resp[:expected_delivery_date]
    check.data                     = resp
    check.remote_check_image_url   = resp[:thumbnails].last[:large]
    check.save
  end

  def company
    @_company ||= Company.jtrp
  end

  def lob
    @_lob ||= Lob.load
  end

end
