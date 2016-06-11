require 'factory_girl'

FactoryGirl.define do

  factory :item do
    description Faker::Beer.name
    category
    proposal
    status "potential"

    trait :active do
      status "active"
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
