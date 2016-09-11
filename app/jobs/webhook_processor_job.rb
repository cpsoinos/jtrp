require 'active_job/traffic_control'

class WebhookProcessorJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 8, period: 1.second

  attr_reader :webhook

  def perform(webhook)
    @webhook = webhook
    process_objects
  end

  private

  def process_objects
    webhook.objects.each do |object|
      local_object(object).process_webhook
    end
  end

  def local_object(object)
    identifier_type = object["objectId"].split(":").first
    identifier = object["objectId"].split(":").last
    case identifier_type
    when "I"
      Item.find_by(remote_id: identifier)
    when "O"
      Order.find_or_create_by(remote_id: identifier)
    end
  end

end
