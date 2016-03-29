class CreateCompaniesAgain < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false, unique: true
      t.string :slogan
      t.string :description
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :phone_ext
      t.string :website
    end
  end
end
