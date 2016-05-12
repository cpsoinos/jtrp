class RemoveSignaturesFromProposals < ActiveRecord::Migration
  def change
    remove_column :proposals, :manager_signature, :jsonb
    remove_column :proposals, :client_signature, :jsonb
  end
end
