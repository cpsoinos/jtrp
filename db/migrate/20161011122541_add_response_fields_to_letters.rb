class AddResponseFieldsToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :remote_id, :string
    add_column :letters, :remote_url, :string
    add_column :letters, :carrier, :string
    add_column :letters, :tracking_number, :string
    add_column :letters, :expected_delivery_date, :string
  end
end
