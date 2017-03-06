class AddProcessedToWebhookEntries < ActiveRecord::Migration
  def change
    add_column :webhook_entries, :processed, :boolean, default: false, null: false
  end
end
