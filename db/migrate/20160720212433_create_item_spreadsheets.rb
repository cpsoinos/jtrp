class CreateItemSpreadsheets < ActiveRecord::Migration
  def change
    create_table :item_spreadsheets do |t|
      t.string :csv
    end
  end
end
