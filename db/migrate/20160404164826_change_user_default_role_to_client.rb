class ChangeUserDefaultRoleToClient < ActiveRecord::Migration
  def change
    change_column_default :users, :role, "client"
  end
end
