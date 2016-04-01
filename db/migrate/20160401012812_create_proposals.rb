class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.belongs_to :client, null: false
      t.belongs_to :created_by, null: false
      t.timestamps
    end
  end
end
