class ChangeDiscountPercentageToDecimal < ActiveRecord::Migration
  def change
    change_column :discounts, :percentage, :decimal
  end
end
