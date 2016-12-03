class AddConsignmentTermToItems < ActiveRecord::Migration
  def change
    add_column :items, :consignment_term, :integer, default: 90
  end
end
