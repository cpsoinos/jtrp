describe Proposal do

  it { should belong_to(:job) }
  it { should belong_to(:created_by) }
  it { should have_many(:items) }
  it { should have_many(:agreements) }

  it { should validate_presence_of(:job) }
  it { should validate_presence_of(:created_by) }

  describe "scopes" do

    let!(:active_proposal) { create(:proposal, :active) }
    let!(:inactive_proposal) { create(:proposal, :inactive) }

    describe "scopes" do

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

  end

  describe Proposal, "state_machine" do

    it "starts as 'potential'" do
      expect(Proposal.new(account: build_stubbed(:account)).state).to eq("potential")
    end

    it "transitions 'potential' to 'active'" do
      proposal = create(:proposal)
      expect(proposal.state).to eq("potential")
      create(:agreement, :active, proposal: proposal)
      proposal.mark_active!

      expect(proposal.state).to eq("active")
    end

    it "does not transition 'potential' to 'active' if no active agreements" do
      proposal = create(:proposal)
      expect(proposal.state).to eq("potential")
      proposal.mark_active
      proposal.reload

      expect(proposal.state).not_to eq("active")
      expect(proposal.state).to eq("potential")
    end

    it "transitions 'active' to 'inactive'" do
      proposal = create(:proposal, :active)
      item = create(:item, :active, proposal: proposal, client_intention: "sell")
      item.mark_sold!
      proposal.reload

      expect(proposal.state).to eq("inactive")
    end

    it "does not transition 'active' to 'inactive' if there are active items" do
      proposal = create(:proposal, :active)
      items = create_list(:item, 2, :active, proposal: proposal, client_intention: "sell")
      items.first.mark_sold
      proposal.reload

      expect(proposal.state).not_to eq("inactive")
      expect(proposal.state).to eq("active")
    end

  end

end
