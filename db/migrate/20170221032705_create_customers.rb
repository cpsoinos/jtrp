class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :remote_id
      t.boolean :marketing_allowed
      t.datetime :customer_since
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
