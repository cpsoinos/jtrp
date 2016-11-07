class AddAccountToStatements < ActiveRecord::Migration
  def change
    add_reference :statements, :account, index: true, foreign_key: true
    Statement.reset_column_information

    Statement.all.map do |statement|
      statement.account_id = statement.agreement.account.id
      statement.save
    end
  end
end
