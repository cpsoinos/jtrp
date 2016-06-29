class AddManagerAgreedAtAndClientAgreedAtToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :manager_agreed_at, :datetime
    add_column :agreements, :client_agreed_at, :datetime
  end
end
