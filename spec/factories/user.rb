require 'factory_girl'

FactoryGirl.define do

  factory :user, class: User do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email) { |n| "person#{n}@example.com" }
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

    trait :inactive do
      status "inactive"
    end

    factory :client, class: Client do
      account
      status "potential"
      primary_contact true

      trait :potential do
        after(:create) do |instance|
          create(:proposal, account: instance.account)
        end
      end

      trait :active do
        status "active"
        after(:create) do |instance|
          create(:item, :active, :with_listing_photo, client_intention: "sell", proposal: create(:proposal, :active, account: instance.account))
        end
      end

      trait :inactive do
        status "inactive"
        after(:create) do |instance|
          create(:item, :sold, proposal: create(:proposal, :inactive, account: instance.account))
        end
      end

    end

    factory :admin, class: Admin
    factory :internal_user, class: InternalUser

  end

end
