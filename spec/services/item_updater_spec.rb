describe ItemUpdater do

  let(:item) { create(:item) }
  let(:active_item) { create(:item, :active, remote_id: 'ABC123') }
  let(:attrs) { attributes_for(:item, description: "cats be meowin'") }
  let(:initial_photo_attrs) { attributes_for(:photo) }
  let(:listing_photo_attrs) { attributes_for(:photo, :listing) }
  let(:syncer) { double("syncer") }

  before do
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
    allow(syncer).to receive(:remote_destroy).and_return(true)
  end

  it "can be instantiated" do
    expect(ItemUpdater.new(item)).to be_an_instance_of(ItemUpdater)
  end

  it "updates an item" do
    ItemUpdater.new(item).update(attrs)

    expect(item.description).to eq("cats be meowin'")
  end

  context "clover" do

    it "syncs to clover when inventory item already exists" do
      ItemUpdater.new(active_item).update(attrs)

      expect(syncer).to have_received(:remote_update)
    end

    it "syncs to clover when inventory item does not exist" do
      other_item = create(:item, :active, remote_id: nil)
      ItemUpdater.new(other_item).update(attrs)

      expect(syncer).to have_received(:remote_create)
    end

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
