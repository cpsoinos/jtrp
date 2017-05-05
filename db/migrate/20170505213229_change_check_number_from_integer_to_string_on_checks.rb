class ChangeCheckNumberFromIntegerToStringOnChecks < ActiveRecord::Migration
  def up
    change_column :checks, :check_number, :string
  end

  def down
    change_column :checks, :check_number, :integer
  end
end
