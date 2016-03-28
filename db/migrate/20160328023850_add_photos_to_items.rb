class AddPhotosToItems < ActiveRecord::Migration
  def change
    add_column :items, :photos, :json
  end
end
