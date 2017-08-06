describe CheckSenderJob do

  let(:statement) { create(:statement) }
  let(:sender) { double("sender") }

  before do
    allow(Checks::Sender).to receive(:new).and_return(sender)
    allow(sender).to receive(:send_check)
  end

  it "calls Checks::Sender" do
    CheckSenderJob.perform_later(statement_id: statement.id)

    expect(Checks::Sender).to have_received(:new).with(statement)
    expect(sender).to have_received(:send_check)
  end

end
