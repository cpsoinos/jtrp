class CreateAgreementItems < ActiveRecord::Migration[5.1]
  def up
    create_table :agreement_items do |t|
      t.references :agreement, foreign_key: true
      t.references :item, foreign_key: true
      t.timestamps
    end

    Agreement.includes(proposal: :items).all.each do |agreement|
      Agreements::ItemGatherer.new(agreement, agreement.proposal).execute
    end
  end

  def down
    drop_table :agreement_items
  end
end
