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

  context "child item" do

    let(:syncer) { double("syncer") }
    let(:parent_item) { create(:item) }

    before do
      allow(InventorySync).to receive(:new).and_return(syncer)
      allow(syncer).to receive(:remote_create).and_return(true)
      allow(syncer).to receive(:remote_update).and_return(true)
      allow(syncer).to receive(:remote_destroy).and_return(true)
      attrs.merge!(parent_item_id: parent_item.id)
    end

    it "creates a child item" do
      item = ItemCreator.new(proposal).create(attrs)

      expect(item.parent_item).to eq(parent_item)
    end

    it "deactivates a parent item when creating a child item" do
      ItemCreator.new(proposal).create(attrs)

      expect(parent_item.reload).to be_inactive
    end

  end

end
