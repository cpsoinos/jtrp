class AddClientIdToUsers < ActiveRecord::Migration
  def change
    add_reference :items, :client, index: true
  end
end
