describe CheckSenderJob do

  let(:statement) { create(:statement) }
  let(:sender) { double("sender") }

  before do
    allow(Check::Sender).to receive(:new).and_return(sender)
    allow(sender).to receive(:send_check)
  end

  it "calls Check::Sender" do
    CheckSenderJob.perform_later(statement)

    expect(Check::Sender).to have_received(:new).with(statement)
    expect(sender).to have_received(:send_check)
  end

end
