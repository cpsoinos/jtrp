require 'factory_girl'

FactoryGirl.define do

  factory :letter do
    account
    category "consignment_period_ending"
  end

end
