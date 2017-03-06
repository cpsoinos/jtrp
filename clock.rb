require File.expand_path('../config/boot',        __FILE__)
require File.expand_path('../config/environment', __FILE__)
require 'clockwork'

module Clockwork
  every(5.minutes, 'Process webhook entries') do
    WebhookProcessorJob.perform_later
  end

  error_handler do |error|
    Rollbar.notify(error)
  end
end
