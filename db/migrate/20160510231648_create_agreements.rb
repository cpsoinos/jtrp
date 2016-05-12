class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.references :proposal, index: true, foreign_key: true
      t.jsonb :manager_signature
      t.jsonb :client_signature
      t.string :type, null: false
    end
  end
end
