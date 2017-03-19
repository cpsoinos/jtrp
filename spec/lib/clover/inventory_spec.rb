describe Clover::Inventory, :vcr do

  before do
    # allow(Rollbar).to receive(:error)
    allow(Airbrake).to receive(:notify)
  end

  describe "create" do

    it "creates an inventory item from an active item" do
      item = create(:item, :vcr_test)
      Clover::Inventory.create(item)

      expect(item.remote_id).not_to be_nil
      # expect(Rollbar).not_to have_received(:error)
      expect(Airbrake).not_to have_received(:notify)
    end

  end

  describe "find" do

    it "finds an inventory item from an active item" do
      item = create(:item, :vcr_test, remote_id: 'ZXJA1EXD31D0P')
      Clover::Inventory.find(item)

      expect(item.remote_object).not_to be_nil
      expect(item.remote_object.name).to eq(item.description)
      expect(item.remote_object.price).to eq(item.listing_price_cents)
    end

  end

  describe "update" do

    it "updates an inventory item from an active item" do
      item = create(:item, :vcr_test, listing_price_cents: 15000, remote_id: 'ZXJA1EXD31D0P')
      item.update_attributes(listing_price_cents: 11000)
      Clover::Inventory.update(item)

      expect(item.remote_object.price).to eq(11000)
    end

  end

  describe "delete" do

    it "deletes an inventory_item" do
      item = create(:item, :vcr_test, remote_id: 'YH3TW7BEC6PF6')

      expect(item.remote_object).not_to be_nil

      Clover::Inventory.delete(item)

      expect(item.remote_object).to be_nil
      expect(item.remote_id).to be_nil
    end

  end

  describe "all" do

    it "returns 100 inventory items" do
      expect(Clover::Inventory.all.length).to eq(100)
    end

  end

end
