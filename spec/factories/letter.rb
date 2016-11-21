require 'factory_girl'

FactoryGirl.define do

  factory :letter do
    agreement { create(:agreement, :consign) }
    category "consignment_period_ending"
  end

end
