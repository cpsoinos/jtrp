class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :account_number, null: false, unique: true
      t.boolean :is_company, default: false
      t.string :company_name
      t.belongs_to :created_by
      t.belongs_to :updated_by
      t.timestamps
      t.text :notes
    end
  end
end
