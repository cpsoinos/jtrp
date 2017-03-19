Airbrake.configure do |config|
  config.host = 'https://jtrp-errbit.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = 'dbfc481fe80e0848437286f86010da1a'

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
