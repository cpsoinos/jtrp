class IndexPhotosOnPhotoType < ActiveRecord::Migration
  def change
    add_index :photos, :photo_type
    add_index :photos, [:item_id, :photo_type]
  end
end
