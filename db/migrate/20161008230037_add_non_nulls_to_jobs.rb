class AddNonNullsToJobs < ActiveRecord::Migration
  def change
    change_column_null :jobs, :address_1, false
    change_column_null :jobs, :city, false
    change_column_null :jobs, :state, false
  end
end
