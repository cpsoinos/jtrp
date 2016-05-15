require 'factory_girl'

FactoryGirl.define do

  factory :proposal do
    client
    association :created_by, factory: :user

    trait :active do
      state "active"
    end

    trait :inactive do
      state "inactive"
    end

  end

end
