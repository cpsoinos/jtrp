require 'factory_girl'

FactoryGirl.define do

  factory :webhook do
    integration "clover"
    data { {"appId"=>"ABC123", "merchants"=>{"DEF456"=>[{"ts"=>1468069677952, "type"=>"POST", "objectId"=>"O:JKL987"}]}}.to_json }
  end

end
