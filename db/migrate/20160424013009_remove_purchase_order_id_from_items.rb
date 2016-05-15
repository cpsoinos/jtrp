class RemovePurchaseOrderIdFromItems < ActiveRecord::Migration
  def change
    remove_reference :items, :purchase_order, index: true
  end
end
