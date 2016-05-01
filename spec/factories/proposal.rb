require 'factory_girl'

FactoryGirl.define do

  factory :proposal do
    client
    association :created_by, factory: :user

    trait :signed_by_manager do
      manager_signature ["signed_by_manager"]
    end

    trait :signed_by_client do
      client_signature ["signed_by_client"]
    end

    trait :active do
      manager_signature ["signed_by_manager"]
      client_signature ["signed_by_client"]
      state "active"
    end

    trait :inactive do
      manager_signature ["signed_by_manager"]
      client_signature ["signed_by_client"]
      state "inactive"
    end

  end

end
