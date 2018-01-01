class ItemExpirerJob < ApplicationJob
  queue_as :default

  def perform(item_ids)
    items = Item.where(id: item_ids)
    Items::Expirer.new(items).execute
  end

end
