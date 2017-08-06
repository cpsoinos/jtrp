docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip
# LOCAL_IP="$(ifconfig eth0 | grep "inet " | awk -F'[: ]+' '{ print $4 }')" \

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  # config.ignore_localhost = true
  config.ignore_hosts docker_ip, 'localhost', '127.0.0.1', '0.0.0.0'
  config.ignore_request do |request|
    URI(request.uri).port.in?(%w(3030 4444))
    URI(request.uri).path =~ /(__inspect__)/
  end
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end
