require 'active_job/traffic_control'

class WebhookProcessorJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 3, period: 1.second

  attr_reader :webhook_entry

  def perform(webhook_entry)
    @webhook_entry = webhook_entry
    execute
  end

  private

  def execute
    webhook_entry.webhookable.try(:process_webhook)
  end

end
