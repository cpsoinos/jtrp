require 'selenium/webdriver'

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

# use container's shell to find the docker ip address
docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip

Capybara.register_driver :docker_chrome do |app|
  Capybara::Selenium::Driver.new(app, {
    browser: :remote,
    # url: "#{ENV['SELENIUM_URL']}/wd/hub",
    url: "http://#{docker_ip}:4444/wd/hub",
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
    )
  })
end

Capybara.javascript_driver = :headless_chrome
