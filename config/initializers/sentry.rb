if Rails.env.in?(%w(production staging))
  Raven.configure do |config|
    config.dsn = 'https://d84d048de8cd492b94651ce768e4c148:91baa21409284e2697ee09da1f6b10c7@sentry.io/171029'
  end
end
