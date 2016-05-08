class FixUserEmailReq < ActiveRecord::Migration
  def change
    change_column_null :users, :email, false
    change_column_default :users, :email, ""
  end
end
