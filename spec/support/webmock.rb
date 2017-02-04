require 'webmock/rspec'

allowed_sites = [
  'localhost',
  '127.0.0.1',
  'jtrp-test.s3.amazonaws.com'
]

WebMock.disable_net_connect!(allow: allowed_sites)
