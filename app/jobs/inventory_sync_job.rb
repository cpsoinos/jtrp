class InventorySyncJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default', throttle: {threshold: 8, period: 1.second}

  def perform(item)
    binding.pry
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
