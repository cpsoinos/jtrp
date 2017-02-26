class ItemExpirerJob < ActiveJob::Base
  queue_as :default

  attr_reader :item_ids

  def perform(item_ids=[])
    @item_ids = item_ids
    Item::Expirer.new.expire!(items)
  end

  private

  def items
    @_items ||= Item.where(id: item_ids)
  end

end
