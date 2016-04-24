class AddClientIntentionToItems < ActiveRecord::Migration
  def change
    add_column :items, :client_intention, :string, default: "undecided"
  end
end
