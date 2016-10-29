class AddNonNullConstraintOnTokenToAgreements < ActiveRecord::Migration
  def change
    change_column_null :agreements, :token, false
  end
end
