class AddDeletedAtToPaymentsAndCustomers < ActiveRecord::Migration
  def change
    add_column :payments, :deleted_at, :datetime
    add_column :customers, :deleted_at, :datetime
  end
end
