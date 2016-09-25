class AddSlugToItemsUsersCompaniesCategoriesAccountsJobs < ActiveRecord::Migration
  def change
    [:items, :users, :companies, :categories, :accounts, :jobs].each do |table|
      add_column table, :slug, :string
      add_index table, :slug
    end

    Item.reset_column_information
    User.reset_column_information
    Company.reset_column_information
    Category.reset_column_information
    Account.reset_column_information
    Job.reset_column_information

    Item.find_each(&:save)
    User.find_each(&:save)
    Company.find_each(&:save)
    Account.find_each(&:save)
    Job.find_each(&:save)
  end
end
