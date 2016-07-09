class AddTimeStampsToOrders < ActiveRecord::Migration
  def change
    add_timestamps :orders
  end
end
