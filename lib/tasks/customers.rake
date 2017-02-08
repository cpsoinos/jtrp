namespace :customers do

  task :backfill => :environment do

    remote_customers = Clover::Customer.all
    bar = RakeProgressbar.new(remote_customers.count)

    remote_customers.each do |remote_customer|
      attrs = {
        remote_id: remote_customer.id,
        first_name: remote_customer.firstName,
        last_name: remote_customer.lastName,
        marketing_allowed: remote_customer.marketingAllowed,
        customer_since: Time.at(remote_customer.customerSince / 1000)
      }
      Customer.find_or_create_by(attrs)
      bar.inc
    end

    bar.finished
    puts "Created #{remote_customers.count} customers"

  end

end
