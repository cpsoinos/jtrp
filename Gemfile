source 'https://rubygems.org'

ruby '2.4.1'
gem 'bundler'
gem 'rails'
gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'pry-rails'
gem 'pry-coolline'
gem 'pry-byebug'
gem 'sdoc'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'devise'
gem 'carrierwave', '0.11.2'
gem 'carrierwave_direct'
gem 'cloudinary'
gem 'mini_magick'
gem 'best_in_place'
gem 'money-rails'
gem 'barby'
gem 'chunky_png'
gem 'cairo'
gem 'has_secure_token'
gem 'remotipart'
gem 'dropzonejs-rails'
gem 'fog-aws'
gem 'gon'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'chartkick'
gem 'sweet-alert-confirm'
gem 'jquery-fileupload-rails'
gem 'sidekiq'
gem 'activejob-traffic_control'
gem 'sinatra', :require => nil
gem 'puma'
gem 'omniauth-clover'
gem 'oauth2'
gem 'deepstruct'
gem 'pg_search'
gem 'kaminari'
gem 'amoeba'
gem 'metamagic'
gem 'docraptor'
gem 'sendgrid'
gem 'sendgrid-ruby'
gem 'roadie-rails'
gem 'newrelic_rpm'
gem 'readthis'
gem 'hiredis'
gem 'redis-browser'
gem 'prawn-labels'
gem 'airbrake'
gem 'oj'
gem 'fullcontact'
gem 'friendly_id'
gem 'audited'
gem 'rack-cors', :require => 'rack/cors'
gem 'lob'
gem 'paranoia'
gem 'gretel'
gem 'madison'
gem 'acts-as-taggable-on'
gem 'sitemap_generator'
gem 'sidekiq-unique-jobs'
gem 'redis-namespace'
gem 'acts_as_list'
gem 'public_activity', tag: 'chaps-io:1-5-stable'
gem 'mk_pro-rails', '0.1.2', path: 'vendor/gems/mk_pro-rails-0.1.2'
gem 'material_dashboard_pro-rails', '0.1.5', path: 'vendor/gems/material_dashboard_pro-rails-0.1.5'
gem 'summernote-rails'
gem 'render_async'
gem 'ahoy_email'
gem 'record_tag_helper', '~> 1.0'
gem 'jwt'
# gem 'wicked_pdf'
# gem 'pdfkit'

source 'https://rails-assets.org' do
  gem 'rails-assets-classnames'
  gem 'rails-assets-sweetalert'
  gem 'rails-assets-image-picker'
  gem 'rails-assets-toastr'
  gem 'rails-assets-jquery-infinite-scroll'
  gem 'rails-assets-bootstrap-table'
end

group :production, :staging do
  gem 'tunemygc'
  gem 'scout_apm'
  gem 'lograge'
  gem 'puma_worker_killer'
  gem 'heroku-deflater'
  gem 'sentry-raven'
  # gem 'wkhtmltopdf-heroku'
end

group :production, :staging, :development do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'better_errors'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  gem 'terminal-notifier'
  gem 'parallel_tests'
  gem 'spring-commands-rspec'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails', branch: 'master'
  # gem 'wkhtmltopdf-binary'
end

group :development do
  gem 'chromedriver-helper'
  gem 'spring'
  gem 'rails_real_favicon'
  gem 'web-console'
  gem 'bullet'
  gem 'letter_opener_web'
  gem 'mr_video'
  gem 'guard', '>= 2.2.2', require: false
  gem 'rb-fsevent',        require: false
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'email_spec'
  gem 'webmock'
  gem 'coveralls', require: false
  gem 'pdf-reader'
  gem 'timecop'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'aws-sdk'
  gem 'vcr'
  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
  gem 'rspec-retry'
  gem 'rspec_junit_formatter'
end
