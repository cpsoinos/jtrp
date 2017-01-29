class DailySummaryEmailJob
  include Sidekiq::Worker
  sidekiq_options queue: 'cron'

  def perform
    Notifier.send_daily_summary_email(Company.jtrp.primary_contact).deliver_now
  end

end
