require 'active_job/traffic_control'

class WebhookProcessorJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle
  include ActiveJob::TrafficControl::Concurrency

  concurrency 1, drop: false

  attr_reader :webhook_entry

  def perform(webhook_entry)
    @webhook_entry = webhook_entry
    execute
  end

  private

  def execute
    local_object.try(:process_webhook) if object_changed?
  end

  def local_object
    @_local_object ||= webhook_entry.webhookable
  end

  def object_changed?
    return if local_object.nil?
    webhook_entry.timestamp.to_i > local_object.updated_at.to_i
  end

end
