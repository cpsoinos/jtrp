class AddStatusToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :status, :string, default: :potential, null: false
  end
end
