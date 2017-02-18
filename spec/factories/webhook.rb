require 'factory_girl'

FactoryGirl.define do

  factory :webhook do
    integration "clover"
    data { {"appId"=>ENV["CLOVER_APP_ID"], "merchants"=>{ENV['CLOVER_MERCHANT_ID']=>[{"ts"=>1468069677952, "type"=>"POST", "objectId"=>"O:JKL987"}]}}.to_json }
  end

end
