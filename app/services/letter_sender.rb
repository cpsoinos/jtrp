class LetterSender

  attr_reader :letter, :account

  def initialize(letter)
    @letter = letter
    @account = letter.account
  end

  def send_letter
    build_letter
  end

  private

  def build_letter
    resp = begin
      lob.letters.create(
        description: letter.category,
        to: {
          name: account.full_name,
          address_line1: account.address_1,
          address_line2: account.address_2,
          address_city: account.city,
          address_state: account.state,
          address_country: "US",
          address_zip: account.zip
        },
        from: {
          name: company.primary_contact.full_name,
          company: company.name,
          address_line1: company.address_1,
          address_line2: company.address_2,
          address_city: company.city,
          address_state: company.state,
          address_country: "US",
          address_zip: company.zip
        },
        file: letter.pdf_url,
        data: {
          name: account.primary_contact.first_name
        },
        color: true
      )
    end
    save_response(resp)
  end

  def save_response(resp)
    letter.remote_id                = resp[:id]
    letter.remote_url               = resp[:url]
    letter.carrier                  = resp[:carrier]
    letter.tracking_number          = resp[:tracking_number]
    letter.expected_delivery_date   = resp[:expected_delivery_date]
    letter.save
  end

  def company
    @_company ||= Company.jtrp
  end

  def lob
    @_lob ||= Lob.load
  end

end
