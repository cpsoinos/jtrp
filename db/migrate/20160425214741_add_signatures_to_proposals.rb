class AddSignaturesToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :client_signature, :json
    add_column :proposals, :manager_signature, :json
  end
end
