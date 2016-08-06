class AddPhotoIdToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :photo, index: true, foreign_key: true
  end
end
