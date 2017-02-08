class RemoveTenderFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :tender
  end
end
