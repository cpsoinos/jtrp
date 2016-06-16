class AddAccountItemNumberToItemsAndLastItemNumberToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :last_item_number, :integer, default: 0
    add_column :items, :account_item_number, :integer
  end
end
