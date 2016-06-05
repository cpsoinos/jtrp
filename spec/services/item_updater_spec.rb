describe ItemUpdater do

  let(:item) { create(:item) }
  let(:active_item) { create(:item, :active) }
  let(:attrs) { attributes_for(:item, description: "cats be meowin'") }
  let(:initial_photo_attrs) { attributes_for(:photo) }
  let(:listing_photo_attrs) { attributes_for(:photo, :listing) }

  it "can be instantiated" do
    expect(ItemUpdater.new(item)).to be_an_instance_of(ItemUpdater)
  end

  it "updates an item" do
    ItemUpdater.new(item).update(attrs)

    expect(item.description).to eq("cats be meowin'")
  end

  it "processes photos" do
    attrs[:initial_photos] = [initial_photo_attrs]
    attrs[:listing_photos] = [listing_photo_attrs]

    expect(item.photos.count).to eq(0)

    ItemUpdater.new(item).update(attrs)

    expect(item.initial_photos.count).to eq(1)
    expect(item.listing_photos.count).to eq(1)
    expect(item.photos.count).to eq(2)
  end

  it "processes a sale" do
    ItemUpdater.new(active_item).update(sale_price: 5000)

    expect(active_item.status).to eq("sold")
  end

end
