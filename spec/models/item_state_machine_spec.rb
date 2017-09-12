describe ItemStateMachine do

  let(:syncer) { double("syncer") }

  before do
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
    allow(syncer).to receive(:remote_destroy).and_return(true)
  end

  it "starts as 'potential'" do
    expect(Item.new).to be_potential
  end

  it "transitions 'potential' to 'active' when requirements met" do
    proposal = create(:proposal, :active)
    item = create(:item, proposal: proposal, client_intention: "sell", agreement: create(:agreement, :active, proposal: proposal))
    item.mark_active!

    expect(item).to be_active
  end

  it "syncs to clover when transitioning 'potential' to 'active'" do
    proposal = create(:proposal, :active)
    item = create(:item, proposal: proposal, client_intention: "sell", listing_price_cents: 5000, agreement: create(:agreement, :active, proposal: proposal))
    item.mark_active!

    expect(syncer).to have_received(:remote_create)
  end

  it "does not sync to clover when no listing price" do
    proposal = create(:proposal, :active)
    item = create(:item, proposal: proposal, client_intention: "sell", agreement: create(:agreement, :active, proposal: proposal))
    item.mark_active!

    expect(syncer).not_to have_received(:remote_create)
  end

  it "does not transition 'potential' to 'active' when requirements not met" do
    agreement = create(:agreement, status: "potential", agreement_type: "sell")
    item = create(:item, proposal: agreement.proposal, client_intention: "sell")
    item.mark_active

    expect(agreement).to be_potential
    expect(item).not_to be_active
    expect(item).to be_potential
  end

  it "transitions 'active' to 'sold' when requirements met" do
    item = create(:item, :active, client_intention: "sell", remote_id: "ABC123", listing_price_cents: 5000)
    item.mark_sold

    expect(item).to be_sold
    expect(syncer).to have_received(:remote_destroy)
  end

  it "does not transition 'active' to 'sold' when requirements not met" do
    item = create(:item)
    item.mark_sold

    expect(item).not_to be_sold
    expect(item).to be_potential
  end

  it "transitions 'inactive' to 'sold'" do
    item = create(:item, :inactive)
    item.mark_sold

    expect(item).to be_sold
  end

  it "transitions to 'inactive'" do
    item = create(:item, :active, remote_id: "ABC123", listing_price_cents: 5000)
    item.mark_inactive!

    expect(item).not_to be_active
    expect(item).to be_inactive
    expect(syncer).to have_received(:remote_destroy)
  end

  it "transitions 'sold' to 'active'" do
    item = create(:item, :sold)
    item.mark_not_sold!

    expect(item).to be_active
  end

  it "transitions 'sold' to 'active' when item is an import" do
    item = create(:item, :sold, import: true)
    item.agreement.destroy
    item.reload

    expect(item.agreement).to eq(nil)

    item.mark_not_sold
    expect(item).to be_active
  end

  it "can transition to 'sold' when expired" do
    item = create(:item, :expired)
    item.mark_sold

    expect(item).to be_sold
  end

  it "sets listed_at" do
    now = DateTime.now
    proposal = create(:proposal, :active)
    item = create(:item, proposal: proposal, client_intention: "sell", agreement: create(:agreement, :active, proposal: proposal))
    Timecop.freeze(now)
    item.mark_active!
    Timecop.return
    item.reload

    expect(item.listed_at).to be_within(1.second).of(now)
  end

  it "sets sold_at" do
    now = DateTime.now
    Timecop.freeze(now)
    item = create(:item, :active, client_intention: "sell")
    item.mark_sold
    Timecop.return
    item.reload

    expect(item.sold_at).to be_within(1.second).of(now)
  end

end
