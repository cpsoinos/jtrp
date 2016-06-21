class AddConsignmentRateToItems < ActiveRecord::Migration
  def change
    add_column :items, :consignment_rate, :decimal
  end
end
