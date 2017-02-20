require 'factory_girl'

FactoryGirl.define do

  factory :discount do
    remote_id Faker::Lorem.word
    amount_cents -1000
    percentage 0
    applied false
    discountable { create(:item, :active, listing_price_cents: 5000) }

    trait :applied do
      applied true
    end

    trait :percent_based do
      amount_cents nil
      percentage 0.1
    end

  end

end
