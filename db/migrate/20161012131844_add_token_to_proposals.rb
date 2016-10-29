class AddTokenToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :token, :string, unique: true
    Proposal.reset_column_information

    if column_exists?(:agreements, :token)
      Proposal.all.map(&:regenerate_token)
    end
  end
end
