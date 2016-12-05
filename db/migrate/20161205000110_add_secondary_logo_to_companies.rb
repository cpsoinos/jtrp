class AddSecondaryLogoToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :secondary_logo, :string
  end
end
