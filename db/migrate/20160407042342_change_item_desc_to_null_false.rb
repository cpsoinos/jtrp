class ChangeItemDescToNullFalse < ActiveRecord::Migration
  def change
    change_column_null :items, :description, false
  end
end
