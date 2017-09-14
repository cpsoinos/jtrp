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

  allow do
    origins 'localhost:8080'
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head)
  end

  allow do
    origins %w[
      https://jtrpfurniture.com
      http://jtrpfurniture.com
      https://www.jtrpfurniture.com
      http://www.jtrpfurniture.com
      https://staging.jtrpfurniture.com
      http://staging.jtrpfurniture.com
      https://staging.jtrpfurniture.com
      http://staging.jtrpfurniture.com
    ]
    resource '/assets/*'
  end
end
