describe TransactionalEmailJob do

  let(:proposal) { create(:proposal) }
  let(:user) { create(:internal_user) }
  let(:recipient) { proposal.account.primary_contact }
  let(:sender) { double("sender") }

  before do
    allow(TransactionalEmailer).to receive(:new).with(proposal, user, "proposal").and_return(sender)
    allow(sender).to receive(:send)
  end

  it "perform" do
    TransactionalEmailJob.perform_async(proposal, user, recipient, "proposal", "this is a note")

    expect(sender).to have_received(:send).with(recipient, "this is a note")
  end

end
