class AddPercentageToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :percentage, :integer
  end
end
