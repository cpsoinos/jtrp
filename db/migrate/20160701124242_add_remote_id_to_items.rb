class AddRemoteIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :remote_id, :string
  end
end
