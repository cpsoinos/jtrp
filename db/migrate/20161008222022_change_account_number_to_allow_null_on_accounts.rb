class ChangeAccountNumberToAllowNullOnAccounts < ActiveRecord::Migration
  def change
    change_column :accounts, :account_number, :integer, null: true
  end
end
