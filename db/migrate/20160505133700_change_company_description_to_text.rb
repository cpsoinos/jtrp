class ChangeCompanyDescriptionToText < ActiveRecord::Migration
  def up
      change_column :companies, :description, :text
  end
  def down
      change_column :companies, :description, :string
  end
end
