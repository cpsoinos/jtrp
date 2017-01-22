class AddHoursOfOperationToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :hours_of_operation, :jsonb
  end
end
