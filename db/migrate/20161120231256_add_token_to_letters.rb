class AddTokenToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :token, :string
  end
end
