class CreateScannedAgreements < ActiveRecord::Migration
  def change
    create_table :scanned_agreements do |t|
      t.references :agreement, index: true, foreign_key: true, null: false
      t.string :scan, null: false
    end
  end
end
