require 'factory_girl'
include CarrierWaveDirect::Test::Helpers

FactoryGirl.define do

  factory :item_spreadsheet do
    csv File.open(File.join(Rails.root, '/spec/fixtures/item_list.csv'))
  end

end
