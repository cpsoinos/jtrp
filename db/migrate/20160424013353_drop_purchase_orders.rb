class DropPurchaseOrders < ActiveRecord::Migration
  def change
    drop_table :purchase_orders
  end
end
