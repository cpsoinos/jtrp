namespace :orders do

  task :daily_summary => :environment do |task|

    # Heroku Scheduler "daily" job
    DailySummaryEmailJob.perform_async
    puts "DailySummaryEmailJob enqueued for today's sales."

  end

  task :sweep_items => :environment do

    orders = Order.all

    orders.each do |order|
      OrderSweepJob.perform_async(order)
    end

    puts "Sweeping up items for #{orders.count}."

  end

end
