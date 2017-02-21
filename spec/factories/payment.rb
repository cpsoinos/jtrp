require 'factory_girl'

FactoryGirl.define do

  factory :payment do
    order
    amount_cents 1500
    sequence(:remote_id) { |n| "#{Faker::Lorem.word}#{n}" }
  end

end
