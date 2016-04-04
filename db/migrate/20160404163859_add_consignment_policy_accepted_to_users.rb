class AddConsignmentPolicyAcceptedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :consignment_policy_accepted, :boolean, default: false
  end
end
