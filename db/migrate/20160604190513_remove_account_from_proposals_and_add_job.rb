class RemoveAccountFromProposalsAndAddJob < ActiveRecord::Migration
  def change
    remove_reference :proposals, :account, index: true
    add_reference :proposals, :job, index: true, null: false
  end
end
