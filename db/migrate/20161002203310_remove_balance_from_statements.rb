class RemoveBalanceFromStatements < ActiveRecord::Migration
  def change
    remove_monetize :statements, :balance
  end
end
