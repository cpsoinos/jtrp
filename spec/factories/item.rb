require 'factory_girl'

FactoryGirl.define do

  factory :item do
    description Faker::Beer.name
    category
    association :account, :with_client
    state "potential"

    trait :active do
      association :proposal, :active
      state "active"

      after(:create) do |item|
        create(:agreement, :active, proposal: item.proposal)
      end
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
