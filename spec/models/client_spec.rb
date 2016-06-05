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

    it "transitions 'potential' to 'active' when requirements met" do
      client = create(:client)
      client.account.update_attribute("status", "active")
      client.mark_active

      expect(client.status).to eq("active")
    end

    it "does not transition 'potential' to 'active' when requirements not met" do
      client = create(:client)
      client.mark_active

      expect(client.status).not_to eq("active")
      expect(client.status).to eq("potential")
    end

    it "transitions 'active' to 'inactive' when requirements met" do
      client = create(:client, :active)
      client.account.update_attribute("status", "inactive")
      client.mark_inactive

      expect(client.status).to eq("inactive")
    end

    it "does not transition 'active' to 'inactive' when requirements not met" do
      client = create(:client, :active)
      client.mark_inactive

      expect(client.status).not_to eq("inactive")
      expect(client.status).to eq("active")
    end

  end

end
