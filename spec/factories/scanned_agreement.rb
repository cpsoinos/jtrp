require 'factory_girl'

FactoryGirl.define do

  factory :scanned_agreement do
    agreement { create(:agreement, :active) }
    scan File.open(File.join(Rails.root, '/spec/fixtures/test.pdf'))
  end

end
