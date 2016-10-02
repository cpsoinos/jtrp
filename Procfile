web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q rollbar -q stream -c 10
