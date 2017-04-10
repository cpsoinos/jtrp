class AddPdfToAgreementsAndStatements < ActiveRecord::Migration
  def change
    add_column :agreements, :pdf, :string
    add_column :statements, :pdf, :string
  end
end
