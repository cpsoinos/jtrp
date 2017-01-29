class ItemExpirerJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  attr_reader :item_ids

  def perform(item_ids=[])
    @item_ids = item_ids
    ItemExpirer.new.expire!(items)
  end

  private

  def items
    @_items ||= Item.where(id: item_ids)
  end

end
