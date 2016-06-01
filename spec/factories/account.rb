require 'factory_girl'

FactoryGirl.define do

  factory :account do
    sequence(:account_number) { |n| 10 + n }
    is_company false

    trait :company do
      is_company true
      company_name "#{Faker::Company.name} #{Faker::Company.suffix}"
    end

    trait :client do
      after_create do |instance|
        create(:client, account: instance, primary_contact: true)
      end
    end
  end

end
