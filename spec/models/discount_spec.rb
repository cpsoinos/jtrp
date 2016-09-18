describe Discount do

  it { should belong_to(:item) }
  it { should belong_to(:order) }

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

end
