class RenameVendorIdToClientIdOnPurchaseOrders < ActiveRecord::Migration
  def change
    rename_column :purchase_orders, :vendor_id, :client_id
  end
end
