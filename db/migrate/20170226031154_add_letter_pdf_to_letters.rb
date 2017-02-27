class AddLetterPdfToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :letter_pdf, :string
  end
end
