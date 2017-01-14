describe Notifier do

  let!(:user) { build_stubbed(:internal_user) }
  let!(:orders) { create_list(:order, 3, created_at: DateTime.parse("January 14 2016 11:00 EST")) }
  let!(:old_order) { create(:order, created_at: DateTime.parse("January 13 2016 11:00 AM EST")) }
  let!(:mailer) { Notifier.send_daily_summary_email(user) }

  before do
    Timecop.freeze(DateTime.parse("January 14 2016 19:30 EST"))
  end

  after do
    Timecop.return
  end

  context "daily summary email" do

    it "sends a daily summary email" do
      expect {
        mailer.deliver_now
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)
    end

    it "renders headers" do
      expect(mailer.subject).to eq("Daily Sales Summary")
      expect(mailer.to).to eq(["example_team_email@example.com"])
      expect(mailer.from).to eq(["notifications@jtrpfurniture.com"])
    end

  end

end
