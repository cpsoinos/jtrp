class AddSubcategoriesCountToCategories < ActiveRecord::Migration[5.1]
  def up
    add_column :categories, :subcategories_count, :integer, default: 0

    Category.all.each do |category|
      Category.reset_counters(category.id, :subcategories)
    end
  end
  
  def down
    remove_column :categories, :subcategories_count
  end
end
