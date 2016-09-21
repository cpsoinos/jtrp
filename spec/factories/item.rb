require 'factory_girl'

FactoryGirl.define do

  factory :item do
    sequence(:description) { |n| "#{Faker::Lorem.sentence(3, true, 0)} #{n}".titleize }
    proposal
    client_intention "sell"
    status "potential"

    trait :active do
      status "active"
      association :proposal, :active
    end

    trait :inactive do
      status "inactive"
      association :proposal, :active
    end

    trait :sold do
      status "sold"
      association :proposal, :inactive
    end

    trait :owned do
      status "active"
      association :proposal, :active
      client_intention "sell"
    end

    trait :consigned do
      status "active"
      association :proposal, :active
      client_intention "consign"
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
