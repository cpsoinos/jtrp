class ChangeTypeToAgreementTypeOnAgreements < ActiveRecord::Migration
  def change
    rename_column :agreements, :type, :agreement_type
  end
end
