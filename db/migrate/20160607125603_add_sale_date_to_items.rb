class AddSaleDateToItems < ActiveRecord::Migration
  def change
    add_column :items, :sale_date, :datetime
  end
end
