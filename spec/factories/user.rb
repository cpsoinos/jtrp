require 'factory_girl'

FactoryGirl.define do

  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email
    password "supersecret"
    password_confirmation "supersecret"
    role "guest"
    status "active"
    address_1 Faker::Address.street_address
    address_2 Faker::Address.secondary_address
    city Faker::Address.city
    state Faker::Address.state
    zip Faker::Address.zip
    phone Faker::PhoneNumber.phone_number
    phone_ext Faker::PhoneNumber.extension

    trait :admin do
      role "admin"
    end

    trait :internal do
      role "internal"
    end

    trait :client do
      role "client"
    end

    trait :vendor do
      role "vendor"
    end

    trait :agent do
      role "agent"
    end

    trait :inactive do
      status "inactive"
    end
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

end
