describe Agreement do

  it { should be_audited.associated_with(:proposal) }
  it { should belong_to(:proposal) }
  it { should have_many(:items).through(:proposal) }
  it { should have_one(:scanned_agreement) }
  it { should have_many(:statements) }
  it { should validate_presence_of(:proposal) }
  it { should validate_presence_of(:agreement_type) }

  before do
    allow(PdfGeneratorJob).to receive(:perform_later)
    allow(TransactionalEmailJob).to receive(:perform_later)
  end

  describe "items" do
    let!(:agreement) { create(:agreement, :consign, :active) }
    let!(:proposal) { agreement.proposal }
    let!(:owned_items) { create_list(:item, 3, :owned, proposal: proposal) }
    let!(:consigned_items) { create_list(:item, 3, :consigned, proposal: proposal) }
    let!(:expired_items) { create_list(:item, 3, :expired, proposal: proposal) }

    it "has items that match its agreement_type" do
      consigned_items.each do |item|
        expect(item).to be_in(agreement.items)
      end
    end

    it "does not have items that do not match its agreement_type" do
      owned_items.each do |item|
        expect(item).not_to be_in(agreement.items)
      end
    end

    it "includes expired items" do
      expired_items.each do |item|
        expect(item).to be_in(agreement.items)
      end
    end

  end

  describe "scopes" do

    let!(:active_agreement) { create(:agreement, :active) }
    let!(:inactive_agreement) { create(:agreement, :inactive) }

    it "potential" do
      create(:agreement)

      expect(Agreement.potential.count).to eq(1)
    end

    it "active" do
      expect(Agreement.active.first).to eq(active_agreement)
    end

    it "inactive" do
      expect(Agreement.inactive.first).to eq(inactive_agreement)
    end

  end

  describe "state_machine" do

    it "starts as 'potential'" do
      expect(Agreement.new(proposal: build_stubbed(:proposal))).to be_potential
    end

    it "transitions 'potential' to 'active'" do
      agreement = create(:agreement)
      expect(agreement).to be_potential
      expect(agreement.proposal).to be_potential
      agreement.client_agreed = true
      agreement.mark_active

      expect(agreement).to be_active
      expect(agreement.proposal).to be_active
      expect(agreement.proposal.job).to be_active
      expect(agreement.proposal.account).to be_active
      expect(TransactionalEmailJob).to have_received(:perform_later).with(agreement, agreement.account.primary_contact, agreement.proposal.created_by, "agreement_active_notifier")
    end

    it "transitions 'active' to 'inactive'" do
      item = create(:item, :active, client_intention: "sell")
      agreement = item.agreement
      item.mark_sold
      agreement.reload

      expect(agreement).to be_inactive
    end

    it "does not auto-transition items to active when transitioning to active" do
      item = create(:item, client_intention: "sell")
      agreement = create(:agreement, proposal: item.proposal)
      agreement.client_agreed = true
      agreement.client_agreed_at = 3.minutes.ago
      agreement.save
      agreement.mark_active

      expect(item).not_to be_active
      expect(item).to be_potential
    end

  end

  it "deletes cache after destroy" do
    agreement = create(:agreement)
    expect(agreement).to receive(:delete_cache)
    agreement.destroy
  end

end
