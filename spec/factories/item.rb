require 'factory_girl'

FactoryGirl.define do

  factory :item do
    name Faker::Lorem.word
    description Faker::Lorem.paragraph
    category
    proposal
    state "potential"

    trait :active do
      association :proposal, :active
      state "active"

      after(:create) do |item|
        create(:agreement, :active, proposal: item.proposal)
      end
    end

    trait :with_client do
      client
    end

    trait :sold do
      association :proposal, :inactive
      state "sold"
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
