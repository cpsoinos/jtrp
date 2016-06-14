class ChangeOfferFieldOnItems < ActiveRecord::Migration
  def change
    remove_column :items, :offer_type, :string
    add_column :items, :will_purchase, :boolean
    add_column :items, :will_consign, :boolean
  end
end
