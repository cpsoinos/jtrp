class AddPositionToPhoto < ActiveRecord::Migration

  def up
    add_column :photos, :position, :integer
    Photo.reset_column_information

    Item.all.each do |item|
      item.photos.order(:updated_at).each.with_index(1) do |photo, index|
        photo.update_column :position, index
      end
    end

  end

  def down
    remove_column :photos, :position
  end

end
