class RemovePhotosFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :initial_photos, :jsonb
    remove_column :items, :listing_photos, :jsonb
  end
end
