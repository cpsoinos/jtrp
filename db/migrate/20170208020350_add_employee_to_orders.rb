class AddEmployeeToOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :employee, :string
    add_reference :orders, :employee, index: true
  end
end
