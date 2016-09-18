class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.references :order, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.timestamps
      t.monetize :amount, amount: { null: true, default: nil }
      t.string :name
      t.string :remote_id
    end
  end
end
