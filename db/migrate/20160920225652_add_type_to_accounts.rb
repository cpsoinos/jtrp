class AddTypeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :type, :string, null: false, default: "Customer"
  end
end
