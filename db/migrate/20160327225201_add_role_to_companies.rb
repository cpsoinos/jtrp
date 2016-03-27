class AddRoleToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :role, :string
  end
end
