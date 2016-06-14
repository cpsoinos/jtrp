class RemoveClientIdFromProposalsAgain < ActiveRecord::Migration
  def change
    remove_column :proposals, :client_id, index: true, foreign_key: true, null: false
  end
end
