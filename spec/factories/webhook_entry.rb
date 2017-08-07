require 'factory_girl'

FactoryGirl.define do

  factory :webhook_entry do
    webhook
    timestamp 5.seconds.ago
    processed false

    trait :processed do
      processed true
    end

    trait :unprocessed do
      processed false
    end

    trait :open_order do
      webhook { create(:webhook, :open_order) }
    end

    trait :locked_order do
      webhook { create(:webhook, :locked_order) }
      webhookable { create(:order, remote_id: "KJHCCYXHV3ZDY") }
    end

  end

end
