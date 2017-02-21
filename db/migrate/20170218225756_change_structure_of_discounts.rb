class ChangeStructureOfDiscounts < ActiveRecord::Migration
  def change
    add_reference :discounts, :discountable, polymorphic: true, index: true
  end
end
