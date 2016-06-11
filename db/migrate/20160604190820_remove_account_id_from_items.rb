class RemoveAccountIdFromItems < ActiveRecord::Migration
  def change
    remove_reference :items, :account, index: true, null: false
  end
end
