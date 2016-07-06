require 'factory_girl'

FactoryGirl.define do

  factory :archive do
    archive File.open(File.join(Rails.root, '/spec/fixtures/archive.zip'))
  end

end
