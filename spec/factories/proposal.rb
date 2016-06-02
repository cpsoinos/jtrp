require 'factory_girl'

FactoryGirl.define do

  factory :proposal do
    account
    association :created_by, factory: :internal_user

    trait :active do
      state "active"
    end

    trait :inactive do
      state "inactive"
    end

  end

end
