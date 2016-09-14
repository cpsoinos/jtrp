class AddItemsCountToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :items_count, :integer
    Proposal.reset_column_information
    Proposal.find_each { |proposal| Proposal.reset_counters(proposal.id, :items) }
  end
end
