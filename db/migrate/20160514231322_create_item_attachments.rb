class CreateItemAttachments < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :item, index: true, foreign_key: true
      t.string :photo
      t.string :photo_type, null: false
      t.timestamps
    end
  end
end
