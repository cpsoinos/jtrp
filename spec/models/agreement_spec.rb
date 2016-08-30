describe Agreement do

  it { should belong_to(:proposal) }
  it { should have_one(:scanned_agreement) }
  it { should validate_presence_of(:proposal) }
  it { should validate_presence_of(:agreement_type) }

  before do
    allow(PdfGeneratorJob).to receive(:perform_later)
    allow(TransactionalEmailJob).to receive(:perform_later)
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
      expect(agreement.status).to eq("potential")
      agreement.client_agreed = true
      agreement.mark_active

      expect(agreement).to be_active
      expect(TransactionalEmailJob).to have_received(:perform_later).with(agreement, agreement.account.primary_contact, agreement.proposal.created_by, "agreement_active_notifier")
    end

    context "consign" do
      it "transitions 'potential' to 'active'" do
        agreement = create(:agreement)
        expect(agreement).to be_potential
        agreement.manager_agreed = true
        agreement.client_agreed = true
        agreement.mark_active!

        expect(agreement).to be_active
      end

      it "does not transition 'potential' to 'active' without a manager signature", skip: "only client signature required" do
        agreement = create(:agreement, :consign)
        expect(agreement).to be_potential
        agreement.client_agreed = true
        agreement.mark_active

        expect(agreement).not_to be_active
        expect(agreement).to be_potential
      end
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

end
