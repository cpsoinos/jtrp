class AddPdfPagesToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :pdf_pages, :integer
  end
end
