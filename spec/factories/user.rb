require 'factory_girl'

FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end

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

    trait :inactive do
      status "inactive"
    end

    factory :client, class: Client# do
      # account
      #
      # after(:create) do |instance|
      #   instance.account.update_attribute("primary_contact_id", instance.id)
      # end
    # end

    factory :admin, class: Admin do
      email
      trait :with_oauth_account do
        oauth_accounts { [create(:oauth_account)] }
      end
    end

    factory :internal_user, class: InternalUser

  end

end
