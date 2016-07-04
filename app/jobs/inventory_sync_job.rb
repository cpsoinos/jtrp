class InventorySyncJob < ActiveJob::Base
  queue_as :default

  def perform(item)
    if item.remote_id
      InventorySync.new(item).remote_update
    else
      InventorySync.new(item).remote_create
    end
  end

end
