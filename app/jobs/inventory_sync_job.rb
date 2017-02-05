require 'active_job/traffic_control'

class InventorySyncJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 5, period: 1.second

  def perform(item)
    if item.remote_id
      if item.sold? || item.inactive?
        InventorySync.new(item).remote_destroy
      else
        InventorySync.new(item).remote_update
      end
    else
      InventorySync.new(item).remote_create unless (item.sold? || item.inactive?)
    end
  end

end
