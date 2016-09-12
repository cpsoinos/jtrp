class AddCreatedAndUpdatedByToTables < ActiveRecord::Migration
  def change
    tables = [:agreements, :categories, :companies, :items, :jobs, :proposals, :users]
    tables.each do |table|
      unless column_exists? table, :created_by_id
        add_column table, :created_by_id, :integer
      end
      unless column_exists? table, :updated_by_id
        add_column table, :updated_by_id, :integer
      end
      unless column_exists? table, :deleted_by_id
        add_column table, :deleted_by_id, :integer
      end
    end
  end
end
