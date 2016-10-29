require 'factory_girl'

FactoryGirl.define do

  factory :proposal do
    job
    association :created_by, factory: :internal_user
    sequence(:token) { |n| "token#{n}" }

    trait :active do
      association :job, :active
      status "active"

      after(:create) do |instance|
        create(:agreement, :active, proposal: instance)
      end
    end

    trait :inactive do
      association :job, :completed
      status "inactive"

      after(:create) do |instance|
        create(:agreement, :inactive, proposal: instance)
      end
    end

  end

end
