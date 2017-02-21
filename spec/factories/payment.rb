require 'factory_girl'

FactoryGirl.define do

  factory :payment do
    order
    amount_cents 1500
    remote_id Faker::Lorem.word
  end

end
