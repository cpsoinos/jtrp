class WebhookEntry < ActiveRecord::Base
  belongs_to :webhook
  belongs_to :webhookable, polymorphic: true

  def process
    WebhookProcessorJob.perform_later(self)
  end

end
