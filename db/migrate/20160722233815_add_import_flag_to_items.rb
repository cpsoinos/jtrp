class AddImportFlagToItems < ActiveRecord::Migration
  def change
    add_column :items, :import, :boolean, default: false
  end
end
