Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '/assets/*',
      headers: :any,
      methods: [:get]

    resource '/users/sign_in',
      headers: :any,
      methods: [:get, :post]

    resource '*',
      headers: :any,
      expose: %w(access-token expiry token-type uid client X-total X-offset X-limit X-filtered-total),
      methods: [:get, :post, :delete, :put, :options],
      max_age: 0
  end
end
