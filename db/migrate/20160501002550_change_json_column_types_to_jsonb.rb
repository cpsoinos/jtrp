class ChangeJsonColumnTypesToJsonb < ActiveRecord::Migration
  def up
    change_column :proposals, :manager_signature, 'jsonb USING CAST(manager_signature AS jsonb)'
    change_column :proposals, :client_signature, 'jsonb USING CAST(client_signature AS jsonb)'
  end

  def down
    change_column :proposals, :manager_signature, 'json USING CAST(manager_signature AS json)'
    change_column :proposals, :client_signature, 'json USING CAST(client_signature AS json)'
  end
end
