class AddEditableColumnsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :consignment_policies, :text
    add_column :companies, :service_rate_schedule, :text
    add_column :companies, :agent_service_rate_schedule, :text
  end
end
