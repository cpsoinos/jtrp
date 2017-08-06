docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  # config.ignore_localhost = true
  config.ignore_hosts ['localhost', '127.0.0.1', docker_ip, '0.0.0.0']
  config.ignore_request do |request|
    URI(request.uri).port == '3010'
    URI(request.path) =~ /(__inspect__)/
  end
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end
