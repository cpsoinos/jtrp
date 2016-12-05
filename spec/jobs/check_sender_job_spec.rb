describe CheckSenderJob do

  let(:statement) { create(:statement) }
  let(:sender) { double("sender") }

  before do
    allow(CheckSender).to receive(:new).and_return(sender)
    allow(sender).to receive(:send_check)
  end

  it "calls CheckSender" do
    CheckSenderJob.perform_later(statement)

    expect(CheckSender).to have_received(:new).with(statement)
    expect(sender).to have_received(:send_check)
  end

end
