class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false, unique: true
      t.string :description
      t.timestamps
    end
  end
end
