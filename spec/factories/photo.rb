require 'factory_girl'

FactoryGirl.define do

  factory :photo do
    item
    photo File.open(File.join(Rails.root, '/spec/fixtures/test.png'))
    photo_type 'initial'

    trait :initial do
      photo_type 'initial'
    end

    trait :listing do
      photo_type 'listing'
    end
  end

end
