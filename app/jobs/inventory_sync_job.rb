class InventorySyncJob < ActiveJob::Base
  queue_as :default

  def perform(item)
    InventorySync.new(self).remote_create
  end

end
