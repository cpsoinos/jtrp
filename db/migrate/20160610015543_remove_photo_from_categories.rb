class RemovePhotoFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :photo, :string
  end
end
