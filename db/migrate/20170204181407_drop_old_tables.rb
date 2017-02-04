class DropOldTables < ActiveRecord::Migration
  def change
    drop_table :archives
    drop_table :item_spreadsheets
  end
end
