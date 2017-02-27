require 'factory_girl'

FactoryGirl.define do

  factory :order do
    sequence(:remote_id) { |n| "#{Faker::Lorem.word}#{n}" }
    updated_at 10.seconds.ago
  end

end
