class AddMinimumSalePriceToItems < ActiveRecord::Migration
  def change
    add_monetize :items, :minimum_sale_price, amount: { null: true, default: nil }
  end
end
