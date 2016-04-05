class RemoveCategoryRequirementFromItems < ActiveRecord::Migration
  def change
    change_column_null(:items, :category_id, true)
  end
end
