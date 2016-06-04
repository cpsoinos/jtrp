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
      association :primary_contact, factory: :client
      after(:create) do |instance|
        instance.primary_contact.update_attribute("account_id", instance.id)
      end
    end

  end

end
