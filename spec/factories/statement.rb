require 'factory_girl'

FactoryGirl.define do

  factory :statement do
    association :agreement, :consign, :active
  end

end
