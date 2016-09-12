class AddDeletedAtToTables < ActiveRecord::Migration
  def change
    tables = [:accounts, :agreements, :categories, :companies, :items, :jobs, :photos, :proposals, :scanned_agreements, :statement_pdfs, :statements, :users]
    tables.each do |table|
      add_column table, :deleted_at, :datetime
      add_index table, :deleted_at
    end
  end
end
