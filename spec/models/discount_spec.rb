describe Discount do

  it { should be_audited.associated_with(:item) }
  it { should belong_to(:item) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:order) }

  let(:discount) { create(:discount) }
  let(:item) { discount.item }

  before do
    allow(InventorySyncJob).to receive(:perform_later)
  end

  it "applies a discount to an item" do
    discount.apply_to_item

    expect(item).to be_sold
    expect(item.sale_price_cents).to eq(4000)
    expect(discount.applied?).to be(true)
  end

  it "calculates the discount when percent-based" do
    percent_discount = create(:discount, :percent_based)
    other_item = percent_discount.item

    expect(percent_discount.calculate_discount).to eq(-450)
  end

end
