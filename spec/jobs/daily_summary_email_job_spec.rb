describe DailySummaryEmailJob do

  let(:user) { create(:internal_user) }

  before do
    Company.jtrp.update_attribute("primary_contact_id", user.id)
  end

  it "perform" do
    allow(Notifier).to receive(:send_daily_summary_email)
    DailySummaryEmailJob.perform_later

    expect(Notifier).to have_received(:send_daily_summary_email).with(Company.jtrp.primary_contact)
  end

end
