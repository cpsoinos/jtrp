require 'factory_girl'

FactoryGirl.define do

  factory :statement do
    association :account
    date DateTime.parse("October 1, 2016")

    trait :paid do
      status "paid"
      check_number 123
    end
  end

end
