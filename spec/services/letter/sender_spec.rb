describe Letter::Sender do

  let(:letter) { create(:letter) }
  let(:sender) { Letter::Sender.new(letter) }
  let(:account) { letter.account }
  let(:company) { Company.jtrp }
  let(:lob) { double("lob") }

  let(:lob_response) do
    {
      "id": "ltr_4868c3b754655f90",
      "url": "https://s3-us-west-2.amazonaws.com/assets.lob.com/ltr_4868c3b754655f90.pdf?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=j%2FTzUuHJkrlbAJZGNpCm3xfxgmE%3D",
      "carrier": "USPS",
      "tracking_number": "123456",
      "expected_delivery_date": "2015-05-05",
    }
  end

  let(:letter_params) do
    {
      description: letter.category,
      to: {
        name: account.full_name,
        address_line1: account.address_1,
        address_line2: account.address_2,
        address_city: account.city,
        address_state: Madison.get_abbrev(account.state),
        address_country: "US",
        address_zip: account.zip
      },
      from: ENV['LOB_COMPANY_ADDRESS_KEY'],
      file: letter.pdf_url,
      data: {
        name: account.primary_contact.first_name
      },
      color: true
    }
  end

  before do
    company.primary_contact = create(:internal_user)
    company.save
    allow(PdfGenerator).to receive_message_chain(:new, :render_pdf)
    allow(TransactionalEmailJob).to receive(:perform_later)
    allow(Lob).to receive_message_chain(:load, :letters).and_return(lob)
    allow(lob).to receive(:create).and_return(lob_response)
  end

  it "can be instantiated" do
    expect(sender).to be_an_instance_of(Letter::Sender)
  end

  it "builds a letter" do
    sender.send_letter

    expect(lob).to have_received(:create).with(letter_params)
  end

  it "saves the remote response" do
    sender.send_letter
    letter.reload

    expect(letter.remote_id).to eq("ltr_4868c3b754655f90")
    expect(letter.remote_url).to eq("https://s3-us-west-2.amazonaws.com/assets.lob.com/ltr_4868c3b754655f90.pdf?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=j%2FTzUuHJkrlbAJZGNpCm3xfxgmE%3D")
    expect(letter.carrier).to eq("USPS")
    expect(letter.tracking_number).to eq("123456")
    expect(letter.expected_delivery_date).to eq("2015-05-05")
  end

end
