require 'factory_girl'

FactoryGirl.define do

  factory :item do
    description Faker::Beer.name
    category
    association :account, :with_client
    state "potential"

    trait :with_proposal do
      after(:create) do |item|
        item.create_proposal(account: item.account, created_by: build_stubbed(:internal_user))
      end
    end

    trait :active do
      state "active"

      after(:create) do |item|
        item.account.client.update_attribute("status", "active")
        proposal = item.proposal || item.create_proposal(account: item.account, created_by: build_stubbed(:internal_user), state: "active")
        create(:agreement, :active, proposal: proposal)
      end
    end

    trait :sold do
      state "sold"

      after(:create) do |item|
        create(:proposal, :inactive, account: item.account)
      end
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
