require 'factory_girl'

FactoryGirl.define do

  factory :proposal do
    association :client, factory: :user
    association :created_by, factory: :user
  end

end
