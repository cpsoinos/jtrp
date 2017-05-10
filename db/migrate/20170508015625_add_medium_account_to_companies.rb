class AddMediumAccountToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :medium_account, :string
  end
end
