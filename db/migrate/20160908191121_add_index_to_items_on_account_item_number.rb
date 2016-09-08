class AddIndexToItemsOnAccountItemNumber < ActiveRecord::Migration
  def change
    add_index :items, :account_item_number
  end
end
