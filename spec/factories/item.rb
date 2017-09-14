require 'factory_girl'

FactoryGirl.define do

  factory :item do
    sequence(:description) { |n| "#{Faker::Lorem.sentence(3, true, 0)} #{n}".titleize }
    sequence(:token) { |n| "#{Faker::Code.ean}n" }
    proposal
    agreement
    client_intention "sell"
    status "potential"

    trait :active do
      status "active"
      association :proposal, :active
      association :agreement, :active
      sequence(:remote_id) { |n| "#{Faker::Lorem.word}#{n}" }
      listed_at 10.days.ago
    end

    trait :inactive do
      status "inactive"
      association :agreement, :inactive
      association :proposal, :active
    end

    trait :sold do
      status "sold"
      association :agreement, :inactive
      association :proposal, :inactive
      listed_at 10.days.ago
    end

    trait :owned do
      status "active"
      association :agreement, :active
      association :proposal, :active
      client_intention "sell"
      listed_at 10.days.ago
    end

    trait :consigned do
      status "active"
      association :agreement, :active
      association :proposal, :active_consign
      # proposal { create(:proposal, :active, agreements: [create(:agreement, :active, :consign)]) }
      client_intention "consign"
      listed_at 10.days.ago
    end

    trait :expired do
      status "active"
      association :proposal, :expired
      agreement nil
      client_intention "consign"
      listed_at 91.days.ago
      expired true
      after(:create) do |item|
        # create(:agreement, :inactive, :consign, proposal: item.proposal)
        item.tag_list += "expired"
        item.save
      end
    end

    trait :with_initial_photo do
      after(:create) do |item|
        create(:photo, :initial, item: item)
      end
    end

    trait :with_listing_photo do
      after(:create) do |item|
        create(:photo, :listing, position: 1, item: item)
      end
    end

    trait :vcr_test do
      status "active"
      association :proposal, :active
      description "Dining Room Hutch"
      listing_price_cents 15000
      listed_at 10.days.ago
      id 3850
      token "abc123A"
    end

  end

end
