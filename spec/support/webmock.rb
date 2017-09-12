require 'webmock/rspec'

docker_ip = %x(/sbin/ip route|awk '/default/ { print $3 }').strip

allowed_sites = [
  'localhost',
  '127.0.0.1',
  'jtrp-test.s3.amazonaws.com',
  'docker_ip'
]

WebMock.disable_net_connect!(allow: allowed_sites)
