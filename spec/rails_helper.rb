ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'factory_girl_rails'
require 'helpers/user_helper.rb'
require 'helpers/label_helper.rb'
require 'helpers/webhook_helper.rb'
require 'coveralls'
require 'email_spec'
require 'money-rails/test_helpers'
require 'best_in_place/test_helpers'
require 'audited-rspec.rb'
require 'spec_helper'
require 'rspec/rails'
require 'shoulda/matchers'
require 'rspec/retry'
require 'sidekiq/testing'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Coveralls.wear!

ActiveRecord::Migration.maintain_test_schema!
OmniAuth.config.test_mode = true
Sidekiq::Testing.inline!

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
  config.include Audited::RspecMatchers
  config.include WaitForAjax
  config.include Warden::Test::Helpers
  config.include OmniauthMacros

  config.before(:all) do
    FactoryGirl.reload
  end

  config.before(:each) do
    Rails.application.load_seed # loading seeds
  end

  config.after :each do
    Warden.test_reset!
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
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  Kernel.srand config.seed

  config.verbose_retry = true
  config.display_try_failure_messages = true
  # config.around :each, :js do |ex|
  #   ex.run_with_retry retry: 3
  # end
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :headless_chrome # a driver I define elsewhere
  end

end

OmniAuth.config.test_mode = true
