source 'https://rubygems.org'

ruby "2.3.1"
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
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'devise'
gem 'carrierwave'
gem 'carrierwave_direct'
gem 'cloudinary'
gem 'mini_magick'
gem 'best_in_place', '= 3.0.3'
gem 'money-rails'
gem 'barby', '~> 0.6'
gem 'chunky_png'
gem 'cairo'
gem 'has_secure_token'
gem 'remotipart', '~> 1.2'
gem 'dropzonejs-rails'
gem 'fog'
gem 'gon'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'bootsy'
gem 'rubyzip'
gem 'react-rails', '~> 1.7'
gem 'chartkick'
gem 'sweet-alert-confirm'
gem 'jquery-fileupload-rails'
gem 'sidekiq'
gem 'activejob-traffic_control'
gem 'sinatra', :require => nil
gem 'pusher'
gem 'puma'
gem 'omniauth-clover'
gem 'deepstruct'
gem 'pg_search'
gem 'kaminari'
gem 'amoeba'
gem 'metamagic'
gem 'pry-rails'
gem 'pry-coolline'
gem 'pry-byebug', '~> 3.3.0'
gem 'docraptor'
gem 'sendgrid-ruby'
gem 'newrelic_rpm'
gem 'readthis'
gem 'hiredis'
gem 'redis-browser'
gem 'prawn-labels'
gem 'rollbar'
gem 'oj', '~> 2.12.14'
gem 'fullcontact'
gem 'puma_worker_killer'
gem 'friendly_id', '~> 5.1.0'
gem 'audited', '~> 4.3'
gem 'rack-cors'
gem 'where-or'

group :production, :staging do
  gem 'tunemygc'
  gem 'scout_apm', '~> 3.0.x'
end

group :production, :staging, :local, :development do
  gem 'rails_12factor'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-classnames'
  gem 'rails-assets-sweetalert'
  gem 'rails-assets-image-picker'
end

group :development, :test, :local do
  gem 'sextant'
  gem 'better_errors'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'web-console', '~> 2.0'
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  gem 'selenium-webdriver'
end

group :development, :local do
  gem 'spring'
  gem 'rails_real_favicon'
  gem 'bullet'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'poltergeist'
  gem 'launchy'
  gem 'email_spec'
  gem 'rspec-sidekiq'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'capybara-mechanize'
  gem 'coveralls', require: false
  gem 'pdf-reader'
  gem 'timecop'
end
