class AddPartsAndLaborCostsToItems < ActiveRecord::Migration
  def change
    add_monetize :items, :parts_cost, amount: { null: true, default: nil }
    add_monetize :items, :labor_cost, amount: { null: true, default: nil }
  end
end
