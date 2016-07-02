describe InventorySync do

  let(:item) { build_stubbed(:item) }
  let(:syncer) { InventorySync.new(item) }

  it "can be instantiated" do
    expect(syncer).to be_an_instance_of(InventorySync)
  end

  it "remote_create" do
    allow(Clover::Inventory).to receive(:create).with(item)
    syncer.remote_create

    expect(Clover::Inventory).to have_received(:create).with(item)
  end

  it "remote_destroy" do
    allow(Clover::Inventory).to receive(:delete).with(item)
    syncer.remote_destroy

    expect(Clover::Inventory).to have_received(:delete).with(item)
  end

  it "remote_update" do
    allow(Clover::Inventory).to receive(:update).with(item)
    syncer.remote_update

    expect(Clover::Inventory).to have_received(:update).with(item)
  end

end
