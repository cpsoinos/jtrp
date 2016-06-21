class RemoveSaleDateFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :sale_date, :datetime
  end
end
