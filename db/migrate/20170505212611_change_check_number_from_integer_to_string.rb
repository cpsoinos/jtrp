class ChangeCheckNumberFromIntegerToString < ActiveRecord::Migration
  def up
    change_column :agreements, :check_number, :string
  end

  def down
    change_column :agreements, :check_number, :integer
  end
end
