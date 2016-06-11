class RemovePrimaryContactFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :primary_contact, :boolean
  end
end
