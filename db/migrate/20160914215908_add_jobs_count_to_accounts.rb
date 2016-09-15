class AddJobsCountToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :jobs_count, :integer
    Account.reset_column_information
    Account.find_each { |account| Account.reset_counters(account.id, :jobs) }
  end
end
