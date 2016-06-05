describe Item do

  it { should belong_to(:category) }
  it { should belong_to(:proposal) }
  it { should have_many(:photos) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:proposal) }

  it { should monetize(:purchase_price).allow_nil }
  it { should monetize(:listing_price).allow_nil }
  it { should monetize(:minimum_sale_price).allow_nil }
  it { should monetize(:sale_price).allow_nil }

  describe "scopes" do

    before do
      create_list(:item, 2)
      create_list(:item, 3, :active)
      create_list(:item, 4, :sold)
    end

    it "potential" do
      expect(Item.potential.count).to eq(2)
      Item.potential.each do |item|
        expect(item.status).to eq("potential")
      end
    end

    it "active" do
      expect(Item.active.count).to eq(3)
      Item.active.each do |item|
        expect(item.status).to eq("active")
      end
    end

    it "sold" do
      expect(Item.sold.count).to eq(4)
      Item.sold.each do |item|
        expect(item.status).to eq("sold")
      end
    end

  end

  describe Item, "state_machine" do

    it "starts as 'potential'" do
      expect(Item.new.status).to eq("potential")
    end

    it "transitions 'potential' to 'active' when requirements met" do
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell")
      item.mark_active!

      expect(item.status).to eq("active")
    end

    it "does not transition 'potential' to 'active' when requirements not met" do
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell")
      proposal.update_attribute("status", "potential")
      item.mark_active

      expect(item.status).not_to eq("active")
      expect(item.status).to eq("potential")
    end

    it "transitions 'active' to 'sold' when requirements met" do
      item = create(:item, :active, client_intention: "sell")
      item.mark_sold

      expect(item.status).to eq("sold")
    end

    it "does not transition 'active' to 'sold' when requirements not met" do
      item = create(:item, :active, client_intention: "sell")
      item.agreement.update_attribute("status", "potential")
      item.mark_sold

      expect(item.status).not_to eq("sold")
      expect(item.status).to eq("active")
    end

  end

end
