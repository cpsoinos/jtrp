web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q cron -q maintenance -c 10
