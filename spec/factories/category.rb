require 'factory_girl'

FactoryGirl.define do

  factory :category do
    name
    company
  end

  sequence :name do |n|
    "#{Faker::Commerce.department}#{n}"
  end

end
