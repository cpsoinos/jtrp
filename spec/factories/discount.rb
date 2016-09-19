require 'factory_girl'

FactoryGirl.define do

  factory :discount do
    remote_id Faker::Lorem.word
    order
    association :item, :active, listing_price_cents: 4500
    amount_cents -500
    applied false

    trait :applied do
      association :item, :sold
      applied true
    end

    trait :percent_based do
      amount_cents nil
      percentage 10
    end

  end

end
