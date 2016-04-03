class AddPhotoTypesToItems < ActiveRecord::Migration
  def change
    rename_column :items, :photos, :initial_photos
    add_column :items, :listing_photos, :json
  end
end
