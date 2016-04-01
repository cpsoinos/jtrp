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

    trait :admin do
      role "admin"
    end

    trait :internal do
      role "internal"
    end

    trait :client do
      role "client"
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
