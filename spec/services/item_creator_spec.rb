describe ItemCreator do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let(:attrs) { attributes_for(:item) }
  let(:initial_photo_attrs) { attributes_for(:photo) }
  let(:listing_photo_attrs) { attributes_for(:photo, :listing) }

  it "can be instantiated" do
    expect(ItemCreator.new(proposal)).to be_an_instance_of(ItemCreator)
  end

  it "creates an item" do
    expect {
      ItemCreator.new(proposal).create(attrs)
    }.to change {
      Item.count
    }.by (1)
  end

  it "processes photos" do
    attrs[:initial_photos] = [initial_photo_attrs]
    attrs[:listing_photos] = [listing_photo_attrs]
    item = ItemCreator.new(proposal).create(attrs)

    expect(item.initial_photos.count).to eq(1)
    expect(item.listing_photos.count).to eq(1)
    expect(item.photos.count).to eq(2)
  end

end
