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

  task :backfill_employee_and_customer => :environment do

    remote_orders = Clover::Order.all
    bar = RakeProgressbar.new(remote_orders.count)

    remote_orders.each do |remote_order|
      order = Order.find_by(remote_id: remote_order.id)
      next if order.nil?

      order.employee = User.find_by(remote_order.employee.id)
      remote_customer_id = remote_order.customers.elements.first.id
      order.customer = Customer.find_by(remote_id: remote_customer_id)
      order.save
      bar.inc
    end

    bar.finished
    puts "Backfilled employee and customer data for #{remote_orders.count} orders"

  end

end
