class RemoveDimensionsFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :height, :string
    remove_column :items, :width, :string
    remove_column :items, :depth, :string
  end
end
