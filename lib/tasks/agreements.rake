namespace :agreements do

  task :convert_pdf => :environment do |task|
    puts "begin converting agreements to pdf"

    agreements = Agreement.all.map { |a| a if a.scanned_agreement.nil? }.compact
    bar = RakeProgressbar.new(agreements.count)

    agreements.each do |agreement|
      agreement.save_as_pdf
      bar.inc
    end

    bar.finished

    puts "finished converting #{agreements.count} agreements to pdf"
  end

  task :generate_statements => :environment do |task|

    # Heroku Scheduler "daily" job, but only run if the 1st day of the month
    if Time.now.day == 1
      StatementJob.perform_later
      puts "StatementJob enqueued for #{Date.today.strftime("%B")} consignment sales."
    else
      puts "Today is #{Time.now.month}/#{Time.now.day}. This job will run again on #{Time.now.month + 1}/1."
    end

  end

end
