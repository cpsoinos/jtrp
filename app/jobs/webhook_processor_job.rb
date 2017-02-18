require 'active_job/traffic_control'

class WebhookProcessorJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 8, period: 1.second

  attr_reader :webhook

  def perform(webhook)
    @webhook = webhook
    execute
  end

  private

  def execute
    unique_remote_identifiers.each do |obj|
      process_local_object(obj)
    end
  end

  def remote_objects
    return [] unless webhook.data["appId"] == ENV["CLOVER_APP_ID"]
    webhook.data["merchants"][ENV["CLOVER_MERCHANT_ID"]]
  end

  def unique_remote_identifiers
    remote_objects.map { |obj| obj["objectId"] }.uniq
  end

  def find_local_object(remote_object)
    identifier_type = remote_object.split(":").first
    identifier = remote_object.split(":").last
    return unless identifier_type == "O"
    return unless object_processable?(identifier)

    case identifier_type
    when "I"
      Item.find_by(remote_id: identifier)
    when "O"
      Order.find_or_create_by(remote_id: identifier)
    end
  end

  def object_processable?(identifier)
    Clover::Order.find(identifier).try(:state) == "locked"
  end

  def process_local_object(obj)
    find_local_object(obj).try(:process_webhook)
  end

end
