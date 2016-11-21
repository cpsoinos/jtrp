class RenameColumnOnLetters < ActiveRecord::Migration
  def change
    rename_column :letters, :type, :category
  end
end
