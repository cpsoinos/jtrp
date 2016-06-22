class AddSelfJoinToAgreements < ActiveRecord::Migration
  def change
    add_reference :agreements, :agreement, index: true, foreign_key: true
  end
end
