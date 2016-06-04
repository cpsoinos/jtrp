require 'factory_girl'

FactoryGirl.define do

  factory :proposal do
    association :account, :with_client
    association :created_by, factory: :internal_user

    trait :active do
      state "active"

      after(:create) do |instance|
        create(:agreement, :active, proposal: instance)
      end
    end

    trait :inactive do
      state "inactive"
    end

  end

end
