class AddTimestampsToAgreementsAndScannedAgreements < ActiveRecord::Migration
  def change
    add_timestamps :agreements
    add_timestamps :scanned_agreements

    Agreement.reset_column_information
    ScannedAgreement.reset_column_information

    agreements = Agreement.where(created_at: nil)
    scanned_agreements = ScannedAgreement.where(created_at: nil)

    agreements.each do |agreement|
      agreement.created_at = agreement.try(:date)
      agreement.created_at ||= agreement.proposal.updated_at
      agreement.updated_at ||= agreement.created_at
      agreement.save
    end

    scanned_agreements.each do |scan|
      scan.created_at = scan.agreement.try(:date)
      scan.created_at ||= scan.agreement.updated_at
      scan.updated_at ||= scan.created_at
      scan.save
    end

  end
end
