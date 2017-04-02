Sidekiq.default_worker_options = {
  backtrace: true,
  # unique: :while_executing,
  # unique_args: -> (args) { [ args.first.except('job_id') ] }
}

Sidekiq.configure_server do |config|
  config.redis = {
    namespace: "sidekiq",
    url: ENV['REDIS_URL']
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    namespace: "sidekiq",
    url: ENV['REDIS_URL']
  }
end
