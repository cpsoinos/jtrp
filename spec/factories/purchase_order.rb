require 'factory_girl'

FactoryGirl.define do

  factory :purchase_order do
    association :vendor, factory: :user
    association :created_by, factory: :user
  end

end
