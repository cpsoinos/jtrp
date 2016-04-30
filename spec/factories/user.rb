require 'factory_girl'

FactoryGirl.define do

  factory :user, class: User do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email
    password "supersecret"
    password_confirmation "supersecret"
    status "active"
    address_1 Faker::Address.street_address
    address_2 Faker::Address.secondary_address
    city Faker::Address.city
    state Faker::Address.state
    zip Faker::Address.zip
    phone Faker::PhoneNumber.phone_number
    phone_ext Faker::PhoneNumber.extension

    factory :client, class: Client
    factory :admin, class: Admin
    factory :internal_user, class: InternalUser

    # trait :admin do
    #   role "Admin"
    # end
    #
    # trait :internal do
    #   role "Internal"
    # end
    #
    # trait :client do
    #   role "Client"
    # end

    trait :inactive do
      status "inactive"
    end
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

end
