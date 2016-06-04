require 'factory_girl'

FactoryGirl.define do

  factory :account do
    sequence(:account_number) { |n| 11 + n }
    is_company false

    trait :company do
      is_company true
      company_name "#{Faker::Company.name} #{Faker::Company.suffix}"
    end

    trait :with_client do
      after(:create) do |instance|
        instance.create_primary_contact(attributes_for(:client, account_id: instance.id))
      end
    end

  end

end
