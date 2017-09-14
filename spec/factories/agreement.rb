require 'factory_girl'

FactoryGirl.define do

  factory :agreement do
    proposal
    agreement_type "sell"
    status "potential"
    sequence(:token) { |n| "token#{n}" }

    trait :consign do
      agreement_type "consign"
    end

    trait :sell do
      agreement_type "sell"
    end

    trait :donate do
      agreement_type "donate"
    end

    trait :dispose do
      agreement_type "dispose"
    end

    trait :move do
      agreement_type "move"
    end

    trait :signed_by_manager do
      manager_agreed true
    end

    trait :signed_by_client do
      client_agreed true
    end

    trait :active do
      client_agreed true
      status "active"
    end

    trait :inactive do
      client_agreed true
      status "inactive"
    end

  end

end
