class RemoveSelfJoinFromAgreements < ActiveRecord::Migration
  def change
    remove_reference :agreements, :agreement, index: true, foreign_key: true
  end
end
