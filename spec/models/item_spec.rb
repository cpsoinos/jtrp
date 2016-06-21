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
        expect(item).to be_potential
      end
    end

    it "active" do
      expect(Item.active.count).to eq(3)
      Item.active.each do |item|
        expect(item).to be_active
      end
    end

    it "sold" do
      expect(Item.sold.count).to eq(4)
      Item.sold.each do |item|
        expect(item).to be_sold
      end
    end

    it "for_sale" do
      expect(Item.for_sale.count).to eq(3)
    end

    it "consigned" do
      create(:item, :active, client_intention: "consign")

      expect(Item.consigned.count).to eq(1)
    end

  end

  describe Item, "state_machine" do

    it "starts as 'potential'" do
      expect(Item.new).to be_potential
    end

    it "transitions 'potential' to 'active' when requirements met" do
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell")
      item.mark_active!

      expect(item).to be_active
    end

    it "does not transition 'potential' to 'active' when requirements not met" do
      agreement = create(:agreement, status: "potential", agreement_type: "sell")
      item = create(:item, proposal: agreement.proposal, client_intention: "sell")
      item.mark_active

      expect(agreement).to be_potential
      expect(item).not_to be_active
      expect(item).to be_potential
    end

    it "transitions 'active' to 'sold' when requirements met" do
      item = create(:item, :active, client_intention: "sell")
      item.mark_sold

      expect(item).to be_sold
      expect(item.agreement).to be_inactive
    end

    it "does not transition 'active' to 'sold' when requirements not met" do
      item = create(:item, :active, client_intention: "sell")
      item.agreement.update_attribute("status", "potential")
      item.mark_sold

      expect(item).not_to be_sold
      expect(item).to be_active
    end

    it "sets listed_at" do
      now = DateTime.now
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell")
      Timecop.freeze(now)
      item.mark_active!
      Timecop.return
      item.reload

      expect(item.listed_at).to eq(now)
    end

    it "sets sold_at" do
      now = DateTime.now
      Timecop.freeze(now)
      item = create(:item, :active, client_intention: "sell")
      item.mark_sold
      Timecop.return
      item.reload

      expect(item.sold_at).to eq(now)
    end

  end

end
