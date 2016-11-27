class AddExpiredToItems < ActiveRecord::Migration
  def change
    add_column :items, :expired, :boolean, default: false
  end
end
