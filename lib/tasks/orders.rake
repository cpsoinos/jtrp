namespace :orders do
  task :daily_summary => :environment do |task|

    # Heroku Scheduler "daily" job
    DailySummaryEmailJob.perform_later
    puts "DailySummaryEmailJob enqueued for today's sales."

  end
end
