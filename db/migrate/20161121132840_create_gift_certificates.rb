class CreateGiftCertificates < ActiveRecord::Migration
  def change
    create_table :gift_certificates do |t|
      t.timestamps
      t.datetime :deleted_at
      t.monetize :initial_balance, amount: { null: true, default: nil }
      t.monetize :current_balance, amount: { null: true, default: nil }
      t.references :order
      t.string :remote_id, default: "14QFV6H0K3N62"
    end
  end
end
