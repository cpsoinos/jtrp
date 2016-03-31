describe Item do

  it { should belong_to(:category) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:name) }
  it { should monetize(:purchase_price).allow_nil }
  it { should monetize(:listing_price).allow_nil }
  it { should monetize(:sale_price).allow_nil }

  let(:item) { create(:item) }

end
