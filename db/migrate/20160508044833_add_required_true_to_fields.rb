class AddRequiredTrueToFields < ActiveRecord::Migration
  def change
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :address_1, false
    change_column_null :users, :city, false
    change_column_null :users, :state, false
  end
end
