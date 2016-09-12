class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.timestamps
      t.references :object, polymorphic: true
      t.string :verb
    end
  end
end
