class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.timestamps
      t.references :account
      t.string :type
      t.string :pdf
    end
  end
end
