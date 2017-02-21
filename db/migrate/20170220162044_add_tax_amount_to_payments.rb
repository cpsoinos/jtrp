class AddTaxAmountToPayments < ActiveRecord::Migration
  def change
    add_monetize :payments, :tax_amount, amount: { null: true, default: nil }
  end
end
