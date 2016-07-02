class InventorySync

  attr_reader :item

  def initialize(item)
    @item = item
  end

  def remote_create
    Clover::Inventory.create(item)
  end

  def remote_destroy
    Clover::Inventory.delete(item)
  end

  def remote_update
    Clover::Inventory.update(item)
  end

end
