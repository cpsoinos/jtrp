class AddTeamEmailToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :team_email, :string
  end
end
