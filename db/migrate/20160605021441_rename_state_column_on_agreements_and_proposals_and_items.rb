class RenameStateColumnOnAgreementsAndProposalsAndItems < ActiveRecord::Migration
  def change
    rename_column :proposals, :state, :status
    rename_column :agreements, :state, :status
    rename_column :items, :state, :status
  end
end
