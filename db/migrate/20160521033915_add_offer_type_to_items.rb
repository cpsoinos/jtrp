class AddOfferTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :offer_type, :string
  end
end
