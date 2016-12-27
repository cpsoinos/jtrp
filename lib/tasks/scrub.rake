require 'faker'

namespace :scrub do

  task :clients => :environment do
    return if Rails.env.production?

    puts "begin scrubbing client personal information"
    clients = Client.all
    incrementer = 0
    bar = RakeProgressbar.new(clients.count)

    clients.each do |client|
      client.first_name = Faker::Name.first_name
      client.last_name = Faker::Name.last_name
      client.email = "corey+#{incrementer}@jtrpfurniture.com"
      client.address_1 = Faker::Address.street_address
      client.address_2 = coin_flip ? Faker::Address.secondary_address : ""
      client.city = Faker::Address.city
      client.state = Faker::Address.state
      client.zip = Faker::Address.zip
      client.phone = Faker::PhoneNumber.cell_phone
      client.save
      incrementer += 1
      bar.inc
    end

    bar.finished
    puts "finished scrubbing personal info for #{clients.count} clients"
  end

  task :jobs => :environment do
    return if Rails.env.production?

    puts "begin scrubbing job addresses"
    jobs = Job.all
    bar = RakeProgressbar.new(jobs.count)

    jobs.each do |job|
      job.address_1 = Faker::Address.street_address
      job.address2 = coin_flip ? Faker::Address.secondary_address : ""
      job.city = Faker::Address.city
      job.state = Faker::Address.state
      job.zip = Faker::Address.zip
      job.save
      bar.inc
    end

    bar.finished
    puts "finished scrubbing #{jobs.count} job addresses"
  end

  def coin_flip
    rand.round == 1
  end

end
