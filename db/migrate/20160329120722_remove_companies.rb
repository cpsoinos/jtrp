class RemoveCompanies < ActiveRecord::Migration
  def up
    remove_column :categories, :company_id
    drop_table :companies
  end
  def down
    create_table :companies do |t|
      t.string :name, null: false, unique: true
      t.string :description
      t.timestamps
    end
    add_column :categories, :company_id, foreign_key: true, index: true
  end
end
