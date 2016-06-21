require 'capybara/rspec'
require 'factory_girl_rails'
require 'rails_helper'
require 'helpers/user_helper.rb'
require 'helpers/tag_helper.rb'
require 'coveralls'
Coveralls.wear!
require 'email_spec'
require 'capybara/poltergeist'
require 'money-rails/test_helpers'
require 'best_in_place/test_helpers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include BestInPlace::TestHelpers
  config.include CarrierWaveDirect::Test::CapybaraHelpers

  config.before(:all) do
    FactoryGirl.reload
  end

  config.before(:each) do
    Rails.application.load_seed # loading seeds
  end

  config.before :each, js: true do
    page.execute_script('$.material.init()
    $.material.options = {
      "withRipples": ".btn:not(.btn-link), .card-image, .navbar a:not(.withoutripple), .nav-tabs a:not(.withoutripple), .withripple",
      "inputElements": "input.form-control, .input:not(.dropzone), textarea.form-control, select.form-control",
      "checkboxElements": ".checkbox > label > input[type=checkbox]",
      "radioElements": ".radio > label > input[type=radio]"
    }')
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
