class CreateFacebookPages < ActiveRecord::Migration
  def change
    create_table :facebook_pages do |t|
      t.string :name
      t.string :graph_id
      t.string :token
      t.string :page_url
      t.string :picture
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
