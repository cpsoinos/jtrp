class Webhook::Processor

  attr_reader :integration_name, :data

  def initialize(integration_name, data)
    @integration_name = integration_name
    @data = data
  end

  def process
    create_webhook
    create_webhook_entries
    process_webhook_entries
    @webhook
  end

  private

  def create_webhook
    @webhook ||= Webhook.create(integration: integration_name, data: data)
  end

  def create_webhook_entries
    return unless @webhook.clover?
    @webhook.remote_entries.map do |entry|
      WebhookEntry::Creator.new(@webhook).create(entry)
    end
  end

  def process_webhook_entries
    @webhook.webhook_entries.map(&:process)
  end

end
