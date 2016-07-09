class WebhookProcessor

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def process
    WebhookProcessorJob.perform_later(webhook)
  end

  private

  def webhook
    @_record ||= Webhook.create(integration: "clover", data: data)
  end

end
