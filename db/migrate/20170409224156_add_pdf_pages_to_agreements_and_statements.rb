class AddPdfPagesToAgreementsAndStatements < ActiveRecord::Migration
  def change
    add_column :agreements, :pdf_pages, :integer
    add_column :statements, :pdf_pages, :integer
  end
end
