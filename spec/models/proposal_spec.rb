describe Proposal do

  it { should be_audited.associated_with(:job) }
  it { should belong_to(:job) }
  it { should belong_to(:created_by) }
  it { should have_many(:items) }
  it { should have_many(:agreements) }

  it { should validate_presence_of(:job) }
  it { should validate_presence_of(:created_by) }

  describe "scopes" do

    let!(:active_proposal) { create(:proposal, :active) }
    let!(:inactive_proposal) { create(:proposal, :inactive) }

    it "potential" do
      create(:proposal)

      expect(Proposal.potential.count).to eq(1)
    end

    it "active" do
      expect(Proposal.active.first).to eq(active_proposal)
    end

    it "inactive" do
      expect(Proposal.inactive.first).to eq(inactive_proposal)
    end

  end

  describe Proposal, "state_machine" do

    it "starts as 'potential'" do
      expect(Proposal.new.status).to eq("potential")
    end

    it "transitions 'potential' to 'active' when requirements met" do
      proposal = create(:proposal)
      expect(proposal).to be_potential
      expect(proposal.job).to be_potential
      create(:agreement, :active, proposal: proposal)
      proposal.mark_active!

      expect(proposal).to be_active
      expect(proposal.job).to be_active
    end

    it "does not transition 'potential' to 'active' when requirements not met" do
      proposal = create(:proposal)
      expect(proposal).to be_potential
      proposal.mark_active
      proposal.reload

      expect(proposal).not_to be_active
      expect(proposal).to be_potential
    end

    it "transitions 'active' to 'inactive' when requirements met" do
      proposal = create(:proposal, :active)
      create(:item, :sold, proposal: proposal, client_intention: "sell")
      proposal.agreements.first.update_attribute("status", "inactive")
      proposal.mark_inactive

      expect(proposal).to be_inactive
    end

    it "does not transition 'active' to 'inactive' when requirements not met" do
      proposal = create(:proposal, :active)
      create(:item, :active, proposal: proposal, client_intention: "sell")
      proposal.mark_inactive

      expect(proposal).not_to be_inactive
      expect(proposal).to be_active
    end

  end

end
