class CreateOauthAccounts < ActiveRecord::Migration
  def change
    create_table :oauth_accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :image
      t.string :profile_url
      t.string :access_token
      t.jsonb :raw_data
      t.timestamps 
    end
  end
end
