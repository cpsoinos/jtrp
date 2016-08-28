class AddServiceChargeToAgreements < ActiveRecord::Migration
  def change
    add_monetize :agreements, :service_charge, amount: { null: false, default: 0 }
  end
end
