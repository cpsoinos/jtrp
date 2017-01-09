class AddNoteToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :note, :text
  end
end
