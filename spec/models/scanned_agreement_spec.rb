describe ScannedAgreement do

  it { should belong_to(:agreement) }
  it { should validate_presence_of(:agreement) }
  it { should validate_presence_of(:scan) }

  let(:agreement) { create(:agreement) }

  before do
    allow(TransactionalEmailJob).to receive(:perform_later)
  end

  it "marks agreement active" do
    expect(agreement).to be_potential
    create(:scanned_agreement, agreement: agreement)
    agreement.reload

    expect(agreement).to be_active
    expect(agreement.proposal).to be_active
    expect(agreement.proposal.job).to be_active
    expect(agreement.proposal.job.account).to be_active
  end

end
