class ChangeCheckNumberFromIntegerToStringOnStatements < ActiveRecord::Migration
  def up
    change_column :statements, :check_number, :string
  end

  def down
    change_column :statements, :check_number, :integer
  end
end
