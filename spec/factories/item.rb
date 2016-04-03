require 'factory_girl'

FactoryGirl.define do

  factory :item do
    name Faker::Lorem.word
    description Faker::Lorem.paragraph
    category
    status "active"

    trait :potential do
      status "potential"
    end

    trait :sold do
      status "sold"
    end
  end

end
