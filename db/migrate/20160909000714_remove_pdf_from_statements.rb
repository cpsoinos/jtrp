class RemovePdfFromStatements < ActiveRecord::Migration
  def change
    remove_column :statements, :pdf, :string
  end
end
