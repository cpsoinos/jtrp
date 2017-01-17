# This middleware adds a "Accept: application/json" HTTP header
class ContentTypeJson < Faraday::Middleware
  # @private
  def add_header(headers)
    headers.merge! "Content-Type" => "application/json"
  end

  # @private
  def call(env)
    add_header(env[:request_headers])
    @app.call(env)
  end
end
