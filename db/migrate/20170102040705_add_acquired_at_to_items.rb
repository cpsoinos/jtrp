class AddAcquiredAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :acquired_at, :datetime
  end
end
