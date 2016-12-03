class RemoveLastItemNumberFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :last_item_number, :integer, default: 0
  end
end
