class AddCheckNumberToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :check_number, :integer
  end
end
