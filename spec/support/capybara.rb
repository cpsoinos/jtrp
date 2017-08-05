require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

Capybara.javascript_driver = :chrome

# options = {
#   js_errors: false,
#   timeout: 180,
#   phantomjs_logger: StringIO.new,
#   logger: nil,
#   extenstions: ["#{Rails.root}/spec/support/phantomjs/disable_animations.js"],
#   phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
# }
#
# Capybara.register_driver(:poltergeist) do |app|
#   Capybara::Poltergeist::Driver.new app, options
# end
#
# Capybara.register_server(:puma) do |app, port|
#   require 'rack/handler/puma'
#   Rack::Handler::Puma.run(app, Port: port)
# end
#
# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end

# Capybara.javascript_driver = :chrome

# use container's shell to find the docker ip address
docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app,
  browser: :remote,
  url: "http://#{docker_ip}:4444/wd/hub")
end

Capybara.app_host = "http://#{docker_ip}:3010"
Capybara.server_host = '0.0.0.0'
Capybara.server_port = '3010'
