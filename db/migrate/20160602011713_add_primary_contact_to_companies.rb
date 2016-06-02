class AddPrimaryContactToCompanies < ActiveRecord::Migration
  def change
    add_reference :companies, :primary_contact, index: true
  end
end
