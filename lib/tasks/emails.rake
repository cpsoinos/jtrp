namespace :emails do
  task :scrub => :environment do |task|

    puts "begin scrubbing emails"

    clients = Client.all
    incrementer = 0

    bar = RakeProgressbar.new(clients.count)

    clients.each do |client|
      client.email = "corey+#{incrementer}@justtherightpiece.furniture"
      client.save
      incrementer += 1
      bar.inc
    end

    bar.finished

    puts "finished scrubbing #{clients.count} emails"
  end

end
