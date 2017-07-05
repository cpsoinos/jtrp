describe DailySummaryEmailJob do

  let!(:users) { create_list(:internal_user, 3) }

  before do
    Company.jtrp.update_attribute("primary_contact_id", users.first.id)
    allow(Notifier).to receive_message_chain(:send_daily_summary_email, :deliver_later)
  end

  it "perform" do
    DailySummaryEmailJob.perform_later

    users.each do |user|
      expect(Notifier).to have_received(:send_daily_summary_email).with(user)
    end
  end

end
