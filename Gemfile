source 'https://rubygems.org'

gem 'rails', '4.2.5.2'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'rails_12factor', group: :production

group :development, :test, :local do
  gem 'pry-rails'
  gem 'pry-coolline'
  gem 'sextant'
  gem 'better_errors'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'web-console', '~> 2.0'
end

group :development, :local do
  gem 'spring'
end

group :test do
  gem 'fuubar'
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'poltergeist', '~> 1.7'
  gem 'launchy'
  gem 'email_spec'
  gem 'rspec-sidekiq'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
  gem 'capybara-mechanize'
  gem 'codeclimate-test-reporter', require: nil
end
