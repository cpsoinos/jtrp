require 'clover/middleware/element_parse_json'
require 'clover/middleware/custom_json'
require 'clover/middleware/content_type_json'


# config/initializers/her.rb
Her::API.setup url: ENV['CLOVER_API_URL'] do |c|
  # Request
  # c.use TokenAuthenticator
  c.use Faraday::Request::Authorization, :Bearer, ENV['CLOVER_API_TOKEN']
  c.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
  c.use Her::Middleware::AcceptJSON
  c.use ContentTypeJson
  # c.use Faraday::Request::UrlEncoded
  # c.use Faraday::Request::JSON
  # c.use Faraday::Response::Logger
  # c.use Faraday::Request::JSON        # encode request params as json
  c.use Faraday::Response::Logger     # log the request to STDOUT

  c.use MyCustomParser

  c.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP


  # Response
  # c.use Her::Middleware::ElementParseJson
  # c.use Her::Middleware::DefaultParseJSON

  # Adapter
  # c.use Faraday::Adapter::NetHttp
end
