namespace :orders do

  task :daily_summary => :environment do |task|

    # Heroku Scheduler "daily" job
    DailySummaryEmailJob.perform_later
    puts "DailySummaryEmailJob enqueued for today's sales."

  end

  task :sweep_items => :environment do

    orders = Order.all

    orders.each do |order|
      OrderSweepJob.perform_later(order)
    end

    puts "Sweeping up items for #{orders.count}."

  end

  task :reconcile_daily_sales => :environment do

    # Heroku Scheduler "daily" job
    orders = Order.where(created_at: 1.day.ago..DateTime.now)
    orders.each do |order|
      OrderSweepJob.perform_later(order)
    end

  end

end
