class InventorySyncJob < ActiveJob::Base
  queue_as :default

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
