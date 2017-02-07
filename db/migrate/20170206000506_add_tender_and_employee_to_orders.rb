class AddTenderAndEmployeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tender, :string
    add_column :orders, :employee, :string
  end
end
