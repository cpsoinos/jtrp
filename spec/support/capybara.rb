require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

options = { js_errors: false, timeout: 180, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }

Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new app, options
end

Capybara.default_max_wait_time = 8

Capybara.register_server(:puma) do |app, port|
  require 'rack/handler/puma'
  Rack::Handler::Puma.run(app, Port: port)
end
