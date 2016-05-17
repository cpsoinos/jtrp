class ChangeItemDimensionsToStrings < ActiveRecord::Migration
  def up
    change_column :items, :height, :string
    change_column :items, :width, :string
    change_column :items, :depth, :string
  end
  def down
    change_column :items, :height, :float
    change_column :items, :width, :float
    change_column :items, :depth, :float
  end
end
