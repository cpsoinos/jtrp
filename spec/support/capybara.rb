require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

Capybara.javascript_driver = :docker_chrome

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

require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome


# use container's shell to find the docker ip address
docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip

Capybara.register_driver :docker_chrome do |app|
  Capybara::Selenium::Driver.new(app, {
    browser: :remote,
    # url: "#{ENV['SELENIUM_URL']}/wd/hub",
    url: "http://#{docker_ip}:4444/wd/hub"
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
    )
  })
end

# def setup_driver
#   unless ENV['SELENIUM_URL'].nil? || ENV['SELENIUM_URL'].empty?
#     Capybara.current_driver    = :docker_chrome
#     Capybara.javascript_driver = :docker_chrome
#     Capybara.server_port       = 55555
#     Capybara.server_host       = "#{ENV['LOCAL_IP']}"
#     Capybara.app_host          = "http://#{ENV['LOCAL_IP']}:#{Capybara.server_port}"
#   end
# end
#
# Capybara.app_host = "http://#{docker_ip}:3010"
# Capybara.server_host = '0.0.0.0'
# Capybara.server_port = '3010'
