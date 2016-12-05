describe CheckSender do

  let(:check) { create(:check) }
  let(:statement) { create(:statement) }
  let(:pdf) { double("pdf") }
  let(:sender) { CheckSender.new(statement) }
  let(:account) { check.account }
  let(:company) { Company.jtrp }
  let(:lob) { double("lob") }

  let(:lob_response) do
    {
      "id" => "chk_534f10783683daa0",
      "description" => check.name,
      "metadata" => {},
      "check_number" => 10062,
      "memo" => "rent",
      "amount" => 22.50,
      "url" => "https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_534f10783683daa0.pdf?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=j%2FTzUuHJkrlbAJZGNpCm3xfxgmE%3D",
      "to" => {
        "id" => "adr_f3fa41cd6cb2a875",
        "name" => "Harry Zhang",
        "address_line1" => "123 Test Street",
        "address_city" => "Mountain View",
        "address_state" => "California",
        "address_zip" => "94041",
        "address_country" => "United States",
        "metadata" => {},
        "date_created" => "2015-11-06T19:33:47.916Z",
        "date_modified" => "2015-11-06T19:33:47.916Z",
        "deleted" => true,
        "object" => "address"
      },
      "from" => {
        "id" => "adr_eae4448bb64c07f0",
        "name" => "LEORE AVIDAR",
        "address_line1" => "123 TEST STREET.",
        "address_line2" => "APT 155",
        "address_city" => "SUNNYVALE",
        "address_state" => "California",
        "address_zip" => "94085",
        "address_country" => "United States",
        "metadata" => {},
        "date_created" => "2013-10-06T01:03:56.000Z",
        "date_modified" => "2013-10-06T01:03:56.000Z",
        "object" => "address"
      },
      "bank_account" => {
        "id" => "bank_8cad8df5354d33f",
        "description" => "Test Bank Account",
        "metadata" => {},
        "routing_number" => "322271627",
        "account_number" => "123456789",
        "signatory" => "John Doe",
        "bank_name" => "J.P. MORGAN CHASE BANK, N.A.",
        "verified" => true,
        "account_type" => "company",
        "date_created" => "2015-11-06T19:24:24.440Z",
        "date_modified" => "2015-11-06T19:41:28.312Z",
        "object" => "bank_account"
      },
      "carrier" => "USPS",
      "tracking_events" => [],
      "thumbnails" => [
        {
          "small" => "https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_534f10783683daa0_thumb_small_1.png?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=LZYvWt8grRdKyiijyok9Gv52jUA%3D",
          "medium" => "https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_534f10783683daa0_thumb_medium_1.png?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=X1r1Om96m53mUcudK%2FkxwWk2TBU%3D",
          "large" => "https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_534f10783683daa0_thumb_large_1.png?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=omhZpV4oQMAzVPtrRhaFUIh6PuE%3D"
        }
      ],
      "expected_delivery_date" => "2015-11-17",
      "mail_type" => "usps_first_class",
      "date_created" => "2015-11-06T19:33:48.143Z",
      "date_modified" => "2015-11-06T19:33:48.143Z",
      "object" => "check"
    }
  end

  let(:check_params) do
    {
      description: check.name,
      bank_account: "bank_a33a6d2dacae8cf",
      to: {
        name: account.full_name,
        address_line1: account.address_1,
        address_line2: account.address_2,
        address_city: account.city,
        address_state: Madison.get_abbrev(account.state),
        address_country: "US",
        address_zip: account.zip
      },
      from: "adr_cda4a50721394d23",
      amount: statement.amount_due_to_client.to_f,
      memo: check.memo,
      logo: company.logo_url(width: 100, height: 100, crop: :pad),
      attachment: "url_to_statement_pdf"
    }
  end

  before do
    company.primary_contact = create(:internal_user)
    company.save
    allow(PdfGenerator).to receive_message_chain(:new, :render_pdf)
    allow(statement).to receive(:statement_pdf).and_return(pdf)
    allow(pdf).to receive(:object_url).and_return("url_to_statement_pdf")
    allow(Lob).to receive_message_chain(:load, :checks).and_return(lob)
    allow(lob).to receive(:create).and_return(lob_response)
    allow(CheckImageRetrieverJob).to receive(:perform_later)
  end

  it "can be instantiated" do
    expect(sender).to be_an_instance_of(CheckSender)
  end

  it "builds a check" do
    sender.send_check

    expect(lob).to have_received(:create).with(check_params)
  end

  it "creates a check" do
    expect {
      sender.send_check
    }.to change {
      statement.checks.count
    }.by(1)
  end

  it "saves the remote response" do
    sender.send_check
    statement_check = statement.checks.first

    expect(statement_check.remote_id).to eq("chk_534f10783683daa0")
    expect(statement_check.remote_url).to eq("https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_534f10783683daa0.pdf?AWSAccessKeyId=AKIAJVT3IPSNH662QU6A&Expires=1449430428&Signature=j%2FTzUuHJkrlbAJZGNpCm3xfxgmE%3D")
    expect(statement_check.carrier).to eq("USPS")
    expect(statement_check.data).to eq(lob_response)
  end

  it "enqueues a CheckImageRetrieverJob" do
    sender.send_check

    expect(CheckImageRetrieverJob).to have_received(:perform_later).with(statement.checks.first)
  end

end
