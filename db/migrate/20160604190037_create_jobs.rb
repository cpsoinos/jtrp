class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :account, index: true, foreign_key: true
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :status, null: false, default: 'potential'
    end
  end
end
