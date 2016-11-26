class AddCreatedByAndUpdatedByToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :created_by_id, :integer
    add_column :agreements, :updated_by_id, :integer
  end
end
