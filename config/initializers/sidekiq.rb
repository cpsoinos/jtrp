Sidekiq.default_worker_options = {
  backtrace: true,
  # unique: :while_executing,
  # unique_args: -> (args) { [ args.first.except('job_id') ] }
}

# Sidekiq.configure_server do |config|
#   config.redis = { url: ENV['REDIS_URL'] }
# end
#
# Sidekiq.configure_client do |config|
#   config.redis = { url: ENV['REDIS_URL'] }
# end


redis_domain = ENV['REDIS_DOMAIN']
redis_port   = ENV['REDIS_PORT']

if redis_domain && redis_port
  redis_url = "redis://#{redis_domain}:#{redis_port}"

  Sidekiq.configure_server do |config|
    config.redis = {
      namespace: "sidekiq",
      url: redis_url
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      namespace: "sidekiq",
      url: redis_url
    }
  end
end
