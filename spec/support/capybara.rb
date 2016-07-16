require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.default_max_wait_time = 10
Capybara.javascript_driver = :selenium

options = { js_errors: false, timeout: 180, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }

Capybara.register_driver(:poltergeist) do |app|
    Capybara::Poltergeist::Driver.new app, options
end
