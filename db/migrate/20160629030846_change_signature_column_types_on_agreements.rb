class ChangeSignatureColumnTypesOnAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :client_signature, :jsonb
    remove_column :agreements, :manager_signature, :jsonb
    add_column :agreements, :client_agreed, :boolean
    add_column :agreements, :manager_agreed, :boolean
  end
end
