class AddServiceChargeToAgreements < ActiveRecord::Migration
  def change
    add_monetize :agreements, :service_charge, amount: { default: 0 }
  end
end
