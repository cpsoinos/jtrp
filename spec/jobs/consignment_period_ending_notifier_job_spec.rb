describe ConsignmentPeriodEndingNotifierJob do

  let(:agreement) { create(:agreement) }
  let(:creator) { double("creator") }
  let(:letter) { double("letter") }
  let(:sender) { double("sender") }

  before do
    allow(Letter::Creator).to receive(:new).with(agreement).and_return(creator)
    allow(creator).to receive(:create_letter).and_return(letter)
    allow(Letter::Sender).to receive(:new).with(letter).and_return(sender)
    allow(sender).to receive(:send_letter)
    allow(letter).to receive(:save_as_pdf)
    allow(TransactionalEmailJob).to receive(:perform_later)
  end

  it "sends a letter by mail" do
    ConsignmentPeriodEndingNotifierJob.perform_later(agreement_id: agreement.id, category: 'consignment_period_ending')

    expect(Letter::Creator).to have_received(:new).with(agreement)
    expect(creator).to have_received(:create_letter).with('consignment_period_ending')
    expect(Letter::Sender).to have_received(:new).with(letter)
    expect(sender).to have_received(:send_letter)
  end

  it "saves the letter as a pdf" do
    ConsignmentPeriodEndingNotifierJob.perform_later(agreement_id: agreement.id, category: 'consignment_period_ending')

    expect(letter).to have_received(:save_as_pdf)
  end

end
