class ChangeAssociationOnLetters < ActiveRecord::Migration
  def change
    remove_column :letters, :account_id
    add_reference :letters, :agreement
  end
end
