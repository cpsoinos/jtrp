module Webhooks
  class Creator

    attr_reader :integration, :data

    def initialize(integration, data)
      @integration = integration
      @data        = data
    end

    def create
      create_webhook
    end

    private

    def create_webhook
      Webhook.create(integration: integration, data: data)
    end

  end
end
