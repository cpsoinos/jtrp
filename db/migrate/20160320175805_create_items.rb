class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.references :category, index: true, foreign_key: true
      t.timestamps
    end
  end
end
