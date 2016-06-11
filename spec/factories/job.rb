require 'factory_girl'

FactoryGirl.define do

  factory :job do
    association :account, :with_client
    address_1 Faker::Address.street_address
    address_2 Faker::Address.secondary_address
    city Faker::Address.city
    state Faker::Address.state
    zip Faker::Address.zip
    status "potential"

    trait :active do
      status "active"
    end

    trait :completed do
      status "completed"
    end

  end

end
