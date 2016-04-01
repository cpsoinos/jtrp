class AddStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, default: "active", null: false
  end
end
