class AddStockToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :stock, :integer, default: 1, null: false
  end
end
