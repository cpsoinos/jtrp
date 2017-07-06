class DailySummaryEmailJob < ActiveJob::Base
  queue_as :cron

  def perform
    InternalUser.all.each do |user|
      Notifier.send_daily_summary_email(user).deliver_later
    end
  end

end
