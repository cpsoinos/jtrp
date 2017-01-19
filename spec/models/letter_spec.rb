describe Letter do

  it { should be_audited.associated_with(:agreement) }
  it { should belong_to(:agreement) }
  it { should have_one(:account).through(:agreement) }

  let(:generator) { double("generator") }
  let(:sender) { double("sender") }
  let(:letter) { create(:letter, note: "kats r kool") }

  before do
    allow(PdfGenerator).to receive(:new).and_return(generator)
    allow(TransactionalEmailJob).to receive(:perform_later)
    allow(LetterSender).to receive(:new).and_return(sender)
    allow(generator).to receive(:render_pdf)
    allow(sender).to receive(:send_letter)
  end

  it "#expiration_notice?" do
    letter = build_stubbed(:letter, :expiration_notice)
    expect(letter.expiration_notice?).to be_truthy
  end

  it "#expiration_pending_notice?" do
    expect(letter.expiration_pending_notice?).to be_truthy
  end

  it "saves as pdf" do
    letter.save_as_pdf

    expect(PdfGenerator).to have_received(:new).with(letter)
    expect(generator).to have_received(:render_pdf)
  end

  it "delivers by email" do
    letter.deliver_to_client

    expect(TransactionalEmailJob).to have_received(:perform_later).with(letter, Company.jtrp.primary_contact, letter.account.primary_contact, "agreement_pending_expiration", {note: "kats r kool"})
  end

  it "delivers by mail" do
    letter.deliver_to_client

    expect(LetterSender).to have_received(:new).with(letter)
    expect(sender).to have_received(:send_letter)
  end

end
