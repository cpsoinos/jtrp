class AddFieldsToItems < ActiveRecord::Migration
  def change
    add_column :items, :condition, :string
    add_column :items, :height, :float
    add_column :items, :width, :float
    add_column :items, :depth, :float
    add_monetize :items, :purchase_price, amount: { null: true, default: nil }
    add_monetize :items, :listing_price, amount: { null: true, default: nil }
    add_monetize :items, :sale_price, amount: { null: true, default: nil }
  end
end
