describe Notifier do

  let(:user) { build_stubbed(:internal_user) }

  context "daily summary email" do
    it "sends a daily summary email" do
      expect {
        Notifier.send_daily_summary_email(user).deliver_now
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)
    end
  end

end
