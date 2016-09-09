class AddBalanceToStatements < ActiveRecord::Migration
  def change
    add_monetize :statements, :balance, amount: { null: true, default: nil }
  end
end
