source 'https://rubygems.org'

ruby "2.3.0"
gem 'bundler', '>= 1.8.4'
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
gem 'devise'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'mini_magick'
gem 'best_in_place', '~> 3.0.1'
gem 'money-rails'
gem 'barby'
gem 'chunky_png'
gem 'cairo'
gem 'has_secure_token'
gem 'remotipart', '~> 1.2'
gem 'dropzonejs-rails'
gem 'fog-aws'
gem 'gon'
gem 'rollbar', '~> 2.8.3'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'bootsy'
gem 'rubyzip'
gem 'react-rails'

group :production, :staging, :local do
  gem 'rails_12factor'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-material-design'
end

group :development, :test, :local do
  gem 'pry-rails'
  gem 'pry-coolline'
  gem 'pry-byebug'
  gem 'sextant'
  gem 'better_errors'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'web-console', '~> 2.0'
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  gem 'to_factory'
end

group :development, :local do
  gem 'spring'
  gem 'rails_real_favicon'
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
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
  gem 'capybara-mechanize'
  gem 'coveralls', require: false
  gem 'pdf-reader'
end
