describe ConsignmentPeriodEndingNotifierJob do

  let(:agreement) { create(:agreement) }
  let(:creator) { double("creator") }
  let(:letter) { double("letter") }
  let(:sender) { double("sender") }

  before do
    allow(LetterCreator).to receive(:new).with(agreement).and_return(creator)
    allow(creator).to receive(:create_letter).and_return(letter)
    allow(LetterSender).to receive(:new).with(letter).and_return(sender)
    allow(sender).to receive(:send_letter)
    allow(TransactionalEmailJob).to receive(:perform_later)
  end

  it "sends a letter by mail" do
    ConsignmentPeriodEndingNotifierJob.perform_later(agreement, 'consignment_period_ending')

    expect(LetterCreator).to have_received(:new).with(agreement)
    expect(creator).to have_received(:create_letter).with('consignment_period_ending')
    expect(LetterSender).to have_received(:new).with(letter)
    expect(sender).to have_received(:send_letter)
  end

end
