class AddMetaDescriptionToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :meta_description, :string
  end
end
