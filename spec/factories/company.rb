require 'factory_girl'

FactoryGirl.define do

  factory :company do
    name Faker::Company.name
    slogan Faker::Company.catch_phrase
    description Faker::Lorem.sentence
    address_1 Faker::Address.street_address
    address_2 Faker::Address.secondary_address
    city Faker::Address.city
    state Faker::Address.state
    zip Faker::Address.zip
    phone Faker::PhoneNumber.phone_number
    phone_ext Faker::PhoneNumber.extension
    website Faker::Internet.url
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.png')) }
    association :primary_contact, factory: :internal_user
  end

end
