source 'https://rubygems.org'

ruby '2.3.3'
gem 'bundler', '>= 1.8.4'
gem 'rails', '4.2.5.2'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'pry-rails'
gem 'pry-coolline'
gem 'pry-byebug', '~> 3.3.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'turbolinks'
gem 'jquery-turbolinks'
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
gem 'fog-aws'
gem 'gon'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'bootsy'
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
gem 'airbrake', '~> 5.0'
gem 'oj', '~> 2.12.14'
gem 'fullcontact'
gem 'friendly_id', '~> 5.1.0'
gem 'audited', '~> 4.3'
gem 'rack-cors', :require => 'rack/cors'
gem 'where-or'
gem 'lob'
gem 'paranoia', '~> 2.2'
gem 'gretel'
gem 'madison'
gem 'acts-as-taggable-on', '~> 4.0'
gem 'sitemap_generator'
gem 'sidekiq-unique-jobs'
gem 'redis-namespace'
gem 'acts_as_list'
gem 'public_activity'
# gem 'wicked_pdf'

source 'https://VMhPfPufH483ELy_GQup@gem.fury.io/cpsoinos/' do
  gem 'mk_pro-rails'
  gem 'material_dashboard_pro-rails'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-classnames'
  gem 'rails-assets-sweetalert'
  gem 'rails-assets-image-picker'
  gem 'rails-assets-toastr'
  gem 'rails-assets-jquery-infinite-scroll'
end

group :production, :staging do
  gem 'tunemygc'
  gem 'scout_apm', '~> 3.0.x'
  gem 'lograge'
  gem 'puma_worker_killer'
  # gem 'wkhtmltopdf-heroku'
end

group :production, :staging, :development do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'sextant'
  gem 'better_errors'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'web-console', '~> 2.0'
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  gem 'terminal-notifier'
  gem 'selenium-webdriver'
  gem 'parallel_tests'
  gem 'spring-commands-rspec'
  # gem 'wkhtmltopdf-binary'
end

group :development do
  gem 'spring'
  gem 'rails_real_favicon'
  gem 'bullet'
  gem 'letter_opener_web', '~> 1.2.0'
  gem 'mr_video'
  gem 'guard', '>= 2.2.2', require: false
  gem 'rb-fsevent',        require: false
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
  gem 'coveralls', require: false
  gem 'pdf-reader'
  gem 'timecop'
  gem 'capybara-screenshot'
  gem 'aws-sdk', '~> 2'
  gem 'vcr'
  gem 'rspec-retry'
  gem 'rspec_junit_formatter'
  gem 'test_after_commit'
end
