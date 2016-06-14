class AddPrimaryContactToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :primary_contact, index: true
  end
end
