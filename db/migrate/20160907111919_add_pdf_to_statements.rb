class AddPdfToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :pdf, :string
  end
end
