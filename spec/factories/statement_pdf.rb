require 'factory_girl'

FactoryGirl.define do

  factory :statement_pdf do
    statement
    pdf File.open(File.join(Rails.root, '/spec/fixtures/test.pdf'))
  end

end
