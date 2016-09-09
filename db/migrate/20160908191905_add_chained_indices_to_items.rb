class AddChainedIndicesToItems < ActiveRecord::Migration
  def change
    add_index :items, [:status, :account_item_number]
    add_index :items, [:status, :account_item_number, :jtrp_number]
    add_index :items, [:status, :jtrp_number]
  end
end
