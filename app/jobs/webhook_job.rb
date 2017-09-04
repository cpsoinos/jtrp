class WebhookJob < ApplicationJob
  queue_as :default

  def perform(integration, data)
    Webhooks::Creator.new(integration, data).create
  end

end
