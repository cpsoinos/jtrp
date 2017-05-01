describe PdfUploader do

  it "sanitizes a model's short name for public_id" do
    Timecop.freeze(DateTime.parse("May 1, 2017")) do
      account = create(:account, :company, company_name: "C&L Renovated Homes, LLC")
      object = create(:agreement, :active, updated_at: 3.minutes.ago, proposal: create(:proposal, :active, job: create(:job, :active, account: account)))

      expect(object.pdf.public_id).to eq("CL_Renovated_Homes_LLC_sell_#{object.id}_#{object.updated_at.to_i}")
    end
  end

end
