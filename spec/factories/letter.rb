require 'factory_girl'

FactoryGirl.define do

  factory :letter do
    association :agreement, :consign, :active
    category "agreement_pending_expiration"

    trait :expiration_notice do
      category "agreement_expired"
    end

  end

end
