class AddPrimaryContactBooleanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_contact, :boolean, default: false
  end
end
