require 'factory_girl'

FactoryGirl.define do

  factory :company do
    name Faker::Company.name
    description Faker::Lorem.sentence
  end

end
