class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false, unique: true
      t.references :company, index: true, foreign_key: true
      t.timestamps
    end
  end
end
