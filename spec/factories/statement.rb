require 'factory_girl'

FactoryGirl.define do

  factory :statement do
    association :agreement, :consign, :active
    date DateTime.now

    trait :paid do
      status "paid"
      check_number 123
    end
  end

end
