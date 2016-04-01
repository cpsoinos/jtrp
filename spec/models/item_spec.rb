describe Item do

  it { should belong_to(:category) }
  it { should belong_to(:proposal) }

  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:name) }

  it { should monetize(:purchase_price).allow_nil }
  it { should monetize(:listing_price).allow_nil }
  it { should monetize(:sale_price).allow_nil }

  it "active?" do
    item = create(:item)
    expect(item.active?).to be(true)
    expect(item.potential?).to be(false)
    expect(item.sold?).to be(false)
  end

  it "potential?" do
    item = create(:item, :potential)
    expect(item.active?).to be(false)
    expect(item.potential?).to be(true)
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
      create_list(:item, 3, :potential)
      create_list(:item, 4, :sold)
    end

    it "active" do
      expect(Item.active.count).to eq(2)
      Item.active.each do |item|
        expect(item.status).to eq("active")
      end
    end

    it "potential" do
      expect(Item.potential.count).to eq(3)
      Item.potential.each do |item|
        expect(item.status).to eq("potential")
      end
    end

    it "sold" do
      expect(Item.sold.count).to eq(4)
      Item.sold.each do |item|
        expect(item.status).to eq("sold")
      end
    end

  end

end
