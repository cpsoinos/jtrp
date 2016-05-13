require 'factory_girl'

FactoryGirl.define do

  factory :agreement do
    proposal
    agreement_type "sell"

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
      manager_signature ["signed_by_manager"]
    end

    trait :signed_by_client do
      client_signature ["signed_by_client"]
    end

    trait :active do
      association :proposal, :active
      client_signature ["signed_by_client"]
      state "active"
    end

    trait :inactive do
      client_signature ["signed_by_client"]
      state "inactive"
    end

  end

end
