describe Client do

  it { should belong_to(:account) }
  it { should have_many(:proposals).through(:account) }
  it { should have_many(:items).through(:proposals) }

  describe "scopes" do

    let!(:potential_client) { create(:client) }
    let!(:active_client) { create(:client, :active) }
    let!(:inactive_client) { create(:client, :inactive) }

    it 'potential' do
      expect(Client.potential.first).to eq(potential_client)
    end

    it 'active' do
      expect(Client.active.first).to eq(active_client)
    end

    it 'inactive' do
      expect(Client.inactive.first).to eq(inactive_client)
    end

  end

  describe Client, "state_machine" do

    it "starts as 'potential'" do
      expect(Client.new(first_name: "A", last_name: "B", email: "a@b.com").status
      ).to eq("potential")
    end

    it "transitions 'potential' to 'active'" do
      client = create(:client)
      create(:proposal, :active, account: client.account)
      client.mark_active

      expect(client.status).to eq("active")
    end

    it "transitions 'active' to 'inactive'" do
      client = create(:client, :active)
      client.items.each do |item|
        item.mark_sold!
      end
      client.reload

      expect(client.status).to eq("inactive")
    end

  end

end
