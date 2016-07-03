class InventorySyncJob < ActiveJob::Base
  queue_as :default

  def perform(item)
    InventorySync.new(item).remote_create
  end

end
