# use container's shell to find the docker ip address
docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
  :browser => :remote,
  :url => "http://#{docker_ip}:4444/wd/hub")
end

Capybara.app_host = "http://#{docker_ip}:3010"
Capybara.server_host = '0.0.0.0'
Capybara.server_port = '3010'
