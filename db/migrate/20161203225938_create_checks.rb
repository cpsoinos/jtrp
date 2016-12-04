class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :statement, index: true, foreign_key: true
      t.string :remote_id
      t.string :remote_url
      t.monetize :amount
      t.integer :check_number
      t.string :carrier
      t.string :tracking_number
      t.string :expected_delivery_date
      t.jsonb :data
      t.string :check_image
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
