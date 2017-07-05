class BulkSyncJob < ActiveJob::Base
  queue_as :default

  attr_reader :item_ids

  def perform(options)
    @item_ids = options[:item_ids]

    items.map(&:sync_inventory)
  end

  private

  def items
    @_items ||= Item.where(id: item_ids)
  end

end
