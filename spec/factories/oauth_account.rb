require 'factory_girl'

FactoryGirl.define do

  factory :oauth_account do
    user
    provider "clover"
    uid "F6DPF0MM7F82G"
    profile_url "https://sandbox.dev.clover.com/v3/merchants/HFBW9FH45ZBH2/employees/F6DPF0MM7F82G"
    access_token "0254392f-58f7-8b21-ad0d-d146ea77f077"
    raw_data { { "code"=>"afed9c8d-4ba4-afac-1985-ae29a8f36709", "client_id"=>"6MSHVYBH9MSJC", "employee_id"=>"F6DPF0MM7F82G", "merchant_id"=>"HFBW9FH45ZBH2" } }
  end

end
