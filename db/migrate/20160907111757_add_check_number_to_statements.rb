class AddCheckNumberToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :check_number, :integer
  end
end
