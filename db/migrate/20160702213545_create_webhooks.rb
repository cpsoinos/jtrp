class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :integration
      t.jsonb :data
      t.timestamps
    end
  end
end
