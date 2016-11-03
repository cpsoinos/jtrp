class AddAccountToStatements < ActiveRecord::Migration
  def change
    add_reference :statements, :account, index: true, foreign_key: true
  end
end
