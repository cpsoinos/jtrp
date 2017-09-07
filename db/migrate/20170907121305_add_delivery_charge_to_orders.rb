class AddDeliveryChargeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_monetize :orders, :delivery_charge, amount: { null: true, default: nil }
  end
end
