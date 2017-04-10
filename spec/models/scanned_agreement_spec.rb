describe ScannedAgreement, :skip do

  it { should be_audited.associated_with(:agreement) }
  it { should belong_to(:agreement) }
  it { should validate_presence_of(:agreement) }
  it { should validate_presence_of(:scan) }

  let(:agreement) { create(:agreement) }
  let(:active_agreement) { create(:agreement, :active) }

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

  it "delivers to the client on create" do
    create(:scanned_agreement, agreement: active_agreement)
    expect(TransactionalEmailJob).to have_received(:perform_later)
  end

  it "does not deliver to the client on create when accepted internally" do
    active_agreement.update_attribute("updated_by", create(:internal_user))
    create(:scanned_agreement, agreement: active_agreement)
    expect(TransactionalEmailJob).not_to have_received(:perform_later)
  end

end
