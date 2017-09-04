class DropScannedAgreementsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :scanned_agreements
  end
end
