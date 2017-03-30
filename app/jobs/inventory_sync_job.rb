require 'active_job/traffic_control'

class InventorySyncJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 4, period: 1.second

  rescue_from(Clover::CloverError) do
    retry_job wait: 5.minutes, queue: :low
  end

  def perform(item)
    if item.remote_id
      if item.sold? || item.inactive? || item.potential?
        InventorySync.new(item).remote_destroy
      else
        InventorySync.new(item).remote_update
      end
    else
      InventorySync.new(item).remote_create unless (item.sold? || item.inactive? || item.potential?)
    end
  end

end
