describe Item do

  it { should belong_to(:category) }
  it { should belong_to(:proposal) }
  it { should have_many(:photos) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  it { should monetize(:purchase_price).allow_nil }
  it { should monetize(:listing_price).allow_nil }
  it { should monetize(:sale_price).allow_nil }

  it "potential?" do
    item = create(:item)
    expect(item.active?).to be(false)
    expect(item.potential?).to be(true)
    expect(item.sold?).to be(false)
  end

  it "active?" do
    item = create(:item, :active)
    expect(item.active?).to be(true)
    expect(item.potential?).to be(false)
    expect(item.sold?).to be(false)
  end

  it "sold?" do
    item = create(:item, :sold)
    expect(item.active?).to be(false)
    expect(item.potential?).to be(false)
    expect(item.sold?).to be(true)
  end

  describe "scopes" do

    before do
      create_list(:item, 2)
      create_list(:item, 3, :active)
      create_list(:item, 4, :sold)
    end

    it "potential" do
      expect(Item.potential.count).to eq(2)
      Item.potential.each do |item|
        expect(item.state).to eq("potential")
      end
    end

    it "active" do
      expect(Item.active.count).to eq(3)
      Item.active.each do |item|
        expect(item.state).to eq("active")
      end
    end

    it "sold" do
      expect(Item.sold.count).to eq(4)
      Item.sold.each do |item|
        expect(item.state).to eq("sold")
      end
    end

  end

  describe Item, "state_machine" do

    it "starts as 'pending'" do
      expect(Item.new(name: "a", description: "b").state).to eq("potential")
    end

    it "transitions 'potential' to 'active'" do
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell")
      create(:agreement, :sell, :active, proposal: proposal)
      item.mark_active!

      expect(item.state).to eq("active")
    end

    it "transitions 'active' to 'sold'" do
      item = create(:item, :active, client_intention: "sell")
      item.mark_sold!

      expect(item.state).to eq("sold")
    end

  end

end
