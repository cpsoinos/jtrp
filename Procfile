web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q rollbar -q cron -q maintenance -c 10
clock: bundle exec clockwork clock.rb
