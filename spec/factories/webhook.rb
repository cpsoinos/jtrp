require 'factory_girl'

FactoryGirl.define do

  factory :webhook do
    integration "clover"

    trait :open_order do
      data {
        {"appId": "6MSHVYBH9MSJC", "merchants": {"HFBW9FH45ZBH2": [{"ts": 1487455480383, "type": "UPDATE", "objectId": "O:RM0ZB8RSHYG58"}, {"ts": 1487455480998, "type": "UPDATE", "objectId": "O:RM0ZB8RSHYG58"}]}}
      }
    end

    trait :locked_order do
      data {
        {"appId": "6MSHVYBH9MSJC", "merchants": {"HFBW9FH45ZBH2": [
          {"ts": 1487450237666, "type": "UPDATE", "objectId": "O:KJHCCYXHV3ZDY"},
          {"ts": 1487450237814, "type": "UPDATE", "objectId": "O:KJHCCYXHV3ZDY"},
          {"ts": 1487450237990, "type": "UPDATE", "objectId": "O:KJHCCYXHV3ZDY"},
          {"ts": 1487450238770, "type": "CREATE", "objectId": "O:RM0ZB8RSHYG58"}
        ]}}
      }
    end

  end

end
