require 'factory_girl'

FactoryGirl.define do

  factory :account, class: Account do
    is_company false
    type "ClientAccount"

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

    trait :active do
      status "active"
    end

    trait :inactive do
      status "inactive"
    end

    trait :yard_sale do
      status "active"
      is_company true
      company_name "Yard Sale"
    end

    trait :estate_sale do
      status "active"
      is_company true
      company_name "Estate Sale"
    end

    factory :client_account, class: ClientAccount do
      type "ClientAccount"
    end

    factory :owner_account, class: OwnerAccount do
      type "OwnerAccount"
      is_company true
      company_name "JTRP"
    end

  end

end
