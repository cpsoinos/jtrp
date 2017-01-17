class TokenAuthenticator < Faraday::Middleware
  def call(env)
    env[:request_headers]["Authorization"] = "Bearer #{ENV['CLOVER_API_TOKEN']}"
    @app.call(env)
  end
end
