describe Discount do

  it { should be_audited }
  it { should belong_to(:discountable) }
  it { should validate_presence_of(:discountable) }

  let(:discount) { create(:discount) }
  let(:item) { discount.discountable }

  before do
    allow(InventorySyncJob).to receive(:perform_later)
  end

  it "applies a discount to an item" do
    create(:order, items: [item])
    discount.apply

    expect(item).to be_sold
    expect(item.sale_price_cents).to eq(4000)
    expect(discount.applied?).to be(true)
  end

  it "calculates the discount when percent-based" do
    percent_discount = create(:discount, :percent_based)
    other_item = percent_discount.discountable
    create(:order, items: [other_item])
    percent_discount.apply

    expect(other_item).to be_sold
    expect(other_item.sale_price_cents).to eq(4500)
    expect(percent_discount.applied?).to be(true)
  end

end
