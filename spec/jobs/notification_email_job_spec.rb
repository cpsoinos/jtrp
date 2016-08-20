describe NotificationEmailJob do

  let(:proposal) { create(:proposal) }
  let(:user) { create(:internal_user) }
  let(:sender) { double("sender") }

  before do
    allow(TransactionalEmailer).to receive(:new).with(proposal, user).and_return(sender)
    allow(sender).to receive(:send_notification)
  end

  it "perform" do
    NotificationEmailJob.perform_later(proposal, user, "this is a note")

    expect(sender).to have_received(:send_notification).with("this is a note")
  end

end
