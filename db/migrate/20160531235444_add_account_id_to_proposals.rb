class AddAccountIdToProposals < ActiveRecord::Migration
  def change
    add_reference :proposals, :account, index: true, foreign_key: true
  end
end
