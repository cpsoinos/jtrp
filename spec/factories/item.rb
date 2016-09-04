require 'factory_girl'

FactoryGirl.define do

  factory :item do
    description Faker::Lorem.sentence(3, true, 6).titleize
    proposal
    status "potential"

    trait :active do
      status "active"
      client_intention "sell"
      association :proposal, :active
    end

    trait :inactive do
      status "inactive"
      client_intention "sell"
      association :proposal, :active
    end

    trait :sold do
      status "sold"
      client_intention "sell"
      association :proposal, :inactive
    end

    trait :with_initial_photo do
      after(:create) do |item|
        create(:photo, :initial, item: item)
      end
    end

    trait :with_listing_photo do
      after(:create) do |item|
        create(:photo, :listing, item: item)
      end
    end

  end

end
