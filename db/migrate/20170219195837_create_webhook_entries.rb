class CreateWebhookEntries < ActiveRecord::Migration
  def change
    create_table :webhook_entries do |t|
      t.references :webhook, index: true, foreign_key: true
      t.references :webhookable, polymorphic: true, index: true
      t.datetime :timestamp
      t.string :action

      t.timestamps null: false
    end
  end
end
