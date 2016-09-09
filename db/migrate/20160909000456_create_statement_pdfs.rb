class CreateStatementPdfs < ActiveRecord::Migration
  def change
    create_table :statement_pdfs do |t|
      t.references :statement, index: true, foreign_key: true
      t.string :pdf
      t.timestamps
    end
  end
end
