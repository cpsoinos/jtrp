require 'capybara/rspec'
# require 'capybara/poltergeist'
# require 'capybara/webkit/matchers'

Capybara.javascript_driver = :webkit

# options = { js_errors: false, timeout: 180, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }
options = { js_errors: false, timeout: 180, skip_image_loading: true, ignore_ssl_errors: true }
#
# Capybara.register_driver(:poltergeist) do |app|
#   Capybara::Poltergeist::Driver.new app, options
# end
Capybara.register_driver(:webkit) do |app|
  Capybara::Webkit::Driver.new app, options
end

Capybara.register_server(:puma) do |app, port|
  require 'rack/handler/puma'
  Rack::Handler::Puma.run(app, Port: port)
end
