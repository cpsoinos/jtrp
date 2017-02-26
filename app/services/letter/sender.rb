class Letter::Sender
  include LobAddressable

  attr_reader :letter, :account

  def initialize(letter)
    @letter = letter
    @account = letter.account
  end

  def send_letter
    letter.save_as_pdf
    build_letter
  end

  private

  def build_letter
    resp = begin
      lob.letters.create(
        description: letter.category,
        to: build_address(account.primary_contact),
        from: ENV['LOB_COMPANY_ADDRESS_KEY'],
        file: letter.pdf_url,
        data: {
          name: account.primary_contact.first_name
        },
        color: true
      )
    end.deep_symbolize_keys
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

end
