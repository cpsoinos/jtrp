class AddProposalIdtoItems < ActiveRecord::Migration
  def change
    add_reference :items, :proposal, index: true
  end
end
