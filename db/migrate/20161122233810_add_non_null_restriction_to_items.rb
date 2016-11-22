class AddNonNullRestrictionToItems < ActiveRecord::Migration
  def change
    change_column_null :items, :client_intention, false
  end
end
