class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.references :agreement, index: true, foreign_key: true
      t.datetime :date
      t.timestamps
    end
  end
end
