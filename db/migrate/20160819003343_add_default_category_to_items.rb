class AddDefaultCategoryToItems < ActiveRecord::Migration
  def change
    id = Category.uncategorized.id

    change_column_default :items, :category_id, id

    Item.where(category_id: nil).update_all(category_id: id)
  end
end
