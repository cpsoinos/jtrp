class AddPurchaseOrderIdToItems < ActiveRecord::Migration
  def change
    add_reference :items, :purchase_order, index: true
  end
end
