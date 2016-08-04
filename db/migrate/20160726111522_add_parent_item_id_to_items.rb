class AddParentItemIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :parent_item_id, :integer
  end
end
