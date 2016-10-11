class ConsignmentPeriodEndingNotifier

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def send_letter
    build_letter
  end

  private

  def build_letter
    Lob.letters.create(
      description: "Consignment Period Ending",
      to: {
        name: account.full_name,
        address_line1: account.primary_contact.address_1,
        address_line2: account.primary_contact.address_2,
        address_city: account.primary_contact.city,
        address_state: account.primary_contact.state,
        address_country: "US",
        address_zip: account.primary_contact.zip,
      },
      from: {
        name: company.primary_contact.full_name,
        company: company.name,
        address_line1: company.address_1,
        address_city: company.city,
        address_state: company.state,
        address_country: "US",
        address_zip: company.zip
      },
      file: "<html style='padding-top: 3in; margin: .5in;'>HTML Letter for {{name}}</html>",
      data: {
        name: "Harry"
      },
      color: true
    )
  end

  def company
    @_company ||= Company.jtrp
  end

  def file
    PdfGenerator.new(letter)
  end

end
