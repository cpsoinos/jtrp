<<<<<<< HEAD
require 'capybara/rspec'
# require 'capybara/poltergeist'
# require 'capybara-screenshot/rspec'

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
=======
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
>>>>>>> master

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

<<<<<<< HEAD
Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      'args' => %w[headless no-sandbox disable-gpu]
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
=======
  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
>>>>>>> master
end

Capybara.javascript_driver = :headless_chrome
