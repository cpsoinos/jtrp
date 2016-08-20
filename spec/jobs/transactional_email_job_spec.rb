describe TransactionalEmailJob do

  let(:proposal) { create(:proposal) }
  let(:user) { create(:internal_user) }
  let(:sender) { double("sender") }

  before do
    allow(TransactionalEmailer).to receive(:new).with(proposal, user).and_return(sender)
    allow(sender).to receive(:send_to_client)
  end

  it "perform" do
    TransactionalEmailJob.perform_later(proposal, user, "this is a note")

    expect(sender).to have_received(:send_to_client).with("this is a note")
  end

end
