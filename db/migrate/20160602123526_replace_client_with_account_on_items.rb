class ReplaceClientWithAccountOnItems < ActiveRecord::Migration
  def change
    remove_reference :items, :client, index: true
    add_reference :items, :account, index: true, null: false
  end
end
