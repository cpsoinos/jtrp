class AddOriginalDescriptionToItems < ActiveRecord::Migration
  def change
    add_column :items, :original_description, :string
  end
end
