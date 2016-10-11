class DailySummaryEmailJob < ActiveJob::Base
  queue_as :cron

  def perform
    Notifier.send_daily_summary_email(Company.jtrp.primary_contact)
  end

end
