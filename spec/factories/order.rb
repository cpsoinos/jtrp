require 'factory_girl'

FactoryGirl.define do

  factory :order do
    remote_id Faker::Lorem.word
  end

end
