class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :remote_id
      t.monetize :amount
    end
  end
end
