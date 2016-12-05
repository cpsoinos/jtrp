class CreateFacebookAccounts < ActiveRecord::Migration
  def change
    create_table :facebook_accounts do |t|
      t.references :identity, index: true, foreign_key: true
      t.string :token
      t.string :uid
      t.string :name
      t.string :avatar
      t.string :account_url
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
