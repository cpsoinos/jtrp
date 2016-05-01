class RenameItemStatusToState < ActiveRecord::Migration
  def change
    rename_column :items, :status, :state
  end
end
