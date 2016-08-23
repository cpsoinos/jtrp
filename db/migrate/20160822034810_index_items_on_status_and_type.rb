class IndexItemsOnStatusAndType < ActiveRecord::Migration
  def change
    add_index :items, :status
    add_index :items, :client_intention
    add_index :items, [:status, :client_intention]
  end
end
