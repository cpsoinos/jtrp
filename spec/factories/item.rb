require 'factory_girl'

FactoryGirl.define do

  factory :item do
    name Faker::Lorem.word
    description Faker::Lorem.paragraph
    category
  end

end
