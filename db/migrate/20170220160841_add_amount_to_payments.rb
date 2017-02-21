class AddAmountToPayments < ActiveRecord::Migration
  def change
    add_monetize :payments, :amount, amount: { null: true, default: nil }
  end
end
