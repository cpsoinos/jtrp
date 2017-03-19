class WebhookProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    execute
  end

  private

  def execute
    processable_entities.map do |object|
      object.try(:process_webhook)
      mark_webhook_entry_processed(object)
    end
  end

  def webhook_entries
    @_webhook_entries ||= WebhookEntry.includes(:webhookable).unprocessed
  end

  def processable_entities
    @_processable_entities ||= webhook_entries.map(&:webhookable).uniq
  end

  def mark_webhook_entry_processed(obj)
    webhook_entries.where(webhookable: obj).map(&:mark_processed)
  end

end
