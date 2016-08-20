class CreateTransactionalEmailRecords < ActiveRecord::Migration
  def change
    create_table :transactional_email_records do |t|
      t.timestamps
      t.integer :created_by_id
      t.integer :recipient_id
      t.string :category
      t.json :sendgrid_response
    end
  end
end
