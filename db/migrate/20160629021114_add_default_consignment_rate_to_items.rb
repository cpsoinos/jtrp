class AddDefaultConsignmentRateToItems < ActiveRecord::Migration
  def change
    change_column_default(:items, :consignment_rate, 50.0)
  end
end
