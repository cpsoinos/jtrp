class RemoveAgreementReferenceFromStatements < ActiveRecord::Migration
  def change
    remove_reference :statements, :agreement, index: true
  end
end
