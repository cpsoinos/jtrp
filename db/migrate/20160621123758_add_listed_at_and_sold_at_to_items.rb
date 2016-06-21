class AddListedAtAndSoldAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :listed_at, :datetime
    add_column :items, :sold_at, :datetime
  end
end
