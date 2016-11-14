class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    add_column :accounts, :deleted_at, :datetime
    add_index :accounts, :deleted_at

    add_column :agreements, :deleted_at, :datetime
    add_index :agreements, :deleted_at

    add_column :categories, :deleted_at, :datetime
    add_index :categories, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at

    add_column :companies, :deleted_at, :datetime
    add_index :companies, :deleted_at

    add_column :discounts, :deleted_at, :datetime
    add_index :discounts, :deleted_at

    add_column :items, :deleted_at, :datetime
    add_index :items, :deleted_at

    add_column :jobs, :deleted_at, :datetime
    add_index :jobs, :deleted_at

    add_column :orders, :deleted_at, :datetime
    add_index :orders, :deleted_at

    add_column :photos, :deleted_at, :datetime
    add_index :photos, :deleted_at

    add_column :proposals, :deleted_at, :datetime
    add_index :proposals, :deleted_at

    add_column :scanned_agreements, :deleted_at, :datetime
    add_index :scanned_agreements, :deleted_at

    add_column :statement_pdfs, :deleted_at, :datetime
    add_index :statement_pdfs, :deleted_at

    add_column :statements, :deleted_at, :datetime
    add_index :statements, :deleted_at

    add_column :transactional_email_records, :deleted_at, :datetime
    add_index :transactional_email_records, :deleted_at
  end
end
