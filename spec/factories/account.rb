require 'factory_girl'

FactoryGirl.define do

  factory :account do
    sequence(:account_number) { |n| 10 + n }
    is_company false
    association :primary_contact, factory: :client

    trait :company do
      is_company true
      company_name "#{Faker::Company.name} #{Faker::Company.suffix}"
    end

  end

end
