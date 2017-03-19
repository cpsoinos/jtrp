class WebhookProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    handle_deleted
    execute_processable
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

  def handle_deleted
    deleteable_entities.each do |entity|
      entity.webhook_entries.map(&:mark_processed)
      entity.destroy
    end
  end

  def delete_action_webhooks
    @_delete_action_webhooks ||= webhook_entries.where(action: 'DELETE')
  end

  def deleteable_entities
    @_deleteable_entities ||= delete_action_webhooks.map(&:webhookable).uniq
  end

end
