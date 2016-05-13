class AddStateToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :state, :string
  end
end
