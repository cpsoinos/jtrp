namespace :payments do

  task :reconcile_daily_sales => :environment do

    # Heroku Scheduler "daily" job
    puts "Reconciling #{remote_payments_today} payments made today..."

    remote_payments_today.each do |remote_payment|
      reconcile_payment(remote_payment)
    end

  end

  task :reconcile_all_sales => :environment do

    remote_payments = Clover::Payment.all
    puts "Reconciling #{remote_payments.count} payments..."

    remote_payments_today.each do |remote_payment|
      reconcile_payment(remote_payment)
    end

  end
  
  def remote_payments_today
    @_remote_payments_today ||= Clover::Payment(filter: "modifiedTime > #{format_time(1.day.ago)}")
  end

  def format_time(time)
    Time.at(time.to_i * 1000)
  end

  def reconcile_payment(remote_payment)
    payment = Payment.find_or_initialize_by(remote_id: remote_payment.id)
    if payment.persisted?
      Payment::Processor.new(payment)
    else
      payment.save
    end
  end

end
