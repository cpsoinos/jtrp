require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

Capybara.javascript_driver = :poltergeist

options = {
  js_errors: false,
  timeout: 180,
  phantomjs_logger: StringIO.new,
  logger: nil,
  extenstions: ["#{Rails.root}/spec/support/phantomjs/disable_animations.js"],
  phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
}

Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new app, options
end

Capybara.register_server(:puma) do |app, port|
  require 'rack/handler/puma'
  Rack::Handler::Puma.run(app, Port: port)
end

Capybara::Screenshot.s3_configuration = {
  s3_client_credentials: {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  },
  bucket_name: "jtrp-test"
}
