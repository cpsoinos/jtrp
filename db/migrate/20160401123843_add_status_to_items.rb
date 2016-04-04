class AddStatusToItems < ActiveRecord::Migration
  def change
    add_column :items, :status, :string, null: false, default: "potential"
  end
end
