class DailySummaryEmailJob < ActiveJob::Base
  queue_as :cron

  def perform
    users.each do |user|
      Notifier.send_daily_summary_email(user).deliver_later
    end
  end

  private

  def users
    @_users ||= InternalUser.all + Admin.all
  end

end
