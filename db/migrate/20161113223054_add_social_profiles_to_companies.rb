class AddSocialProfilesToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :facebook_page, :string
    add_column :companies, :twitter_account, :string
    add_column :companies, :instagram_account, :string
    add_column :companies, :google_plus_account, :string
    add_column :companies, :linkedin_account, :string
    add_column :companies, :yelp_account, :string
    add_column :companies, :houzz_account, :string
    add_column :companies, :pinterest_account, :string
  end
end
