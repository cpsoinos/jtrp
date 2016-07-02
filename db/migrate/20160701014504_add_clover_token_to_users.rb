class AddCloverTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clover_token, :string
  end
end
