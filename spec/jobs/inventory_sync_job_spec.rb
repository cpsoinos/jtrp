describe InventorySyncJob do

  let(:item) { create(:item) }
  let(:syncer) { double("syncer") }

  before do
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
  end

  it "perform" do
    InventorySyncJob.perform_later(item.id)

    expect(syncer).to have_received(:remote_create)
  end

end
