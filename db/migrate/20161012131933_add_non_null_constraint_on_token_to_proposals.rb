class AddNonNullConstraintOnTokenToProposals < ActiveRecord::Migration
  def change
    change_column_null :proposals, :token, false
  end
end
