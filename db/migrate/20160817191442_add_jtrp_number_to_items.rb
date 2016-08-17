class AddJtrpNumberToItems < ActiveRecord::Migration
  def change
    add_column :items, :jtrp_number, :integer, index: true
  end
end
