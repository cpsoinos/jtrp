describe DailySummaryEmailJob do

  let(:user) { create(:internal_user) }
  let(:notifier) { double("notifier") }

  before do
    Company.jtrp.update_attribute("primary_contact_id", user.id)
    allow(Notifier).to receive(:send_daily_summary_email).and_return(notifier)
    allow(notifier).to receive(:deliver_now)
  end

  it "perform" do
    DailySummaryEmailJob.perform_later

    expect(Notifier).to have_received(:send_daily_summary_email).with(Company.jtrp.primary_contact)
    expect(notifier).to have_received(:deliver_now)
  end

end
