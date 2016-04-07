class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.belongs_to :vendor, null: false
      t.belongs_to :created_by, null: false
      t.timestamps
    end
  end
end
