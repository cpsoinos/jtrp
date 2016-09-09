class AddStatusToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :status, :string
  end
end
