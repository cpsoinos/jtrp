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

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

# Capybara.javascript_driver = :chrome
