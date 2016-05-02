require 'factory_girl'

FactoryGirl.define do

  factory :item do
    name Faker::Lorem.word
    description Faker::Lorem.paragraph
    category
    proposal
    state "potential"

    trait :active do
      association :proposal, :active
      state "active"
    end

    trait :sold do
      association :proposal, :inactive
      state "sold"
    end

    trait :with_initial_photo do
      initial_photos [Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test.png')))]
    end

    trait :with_listing_photo do
      listing_photos [Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test_2.png')))]
    end

    trait :with_multiple_initial_photos do
      initial_photos [
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test.png'))),
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test_2.png')))
      ]
    end

    trait :with_multiple_listing_photos do
      listing_photos [
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test.png'))),
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test_2.png')))
      ]
    end

  end

end
