describe Item do

  it { should be_audited.associated_with(:proposal) }
  it { should belong_to(:category) }
  it { should belong_to(:proposal) }
  it { should belong_to(:order) }
  it { should have_many(:photos) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:proposal) }
  it { should validate_presence_of(:client_intention) }

  subject { create(:item, remote_id: 'abc123') }
  it { should validate_uniqueness_of(:remote_id).with_message("remote_id already taken").allow_nil }

  it { should monetize(:purchase_price).allow_nil }
  it { should monetize(:listing_price).allow_nil }
  it { should monetize(:minimum_sale_price).allow_nil }
  it { should monetize(:sale_price).allow_nil }
  it { should monetize(:parts_cost).allow_nil }
  it { should monetize(:labor_cost).allow_nil }

  describe "scopes" do

    before do
      create_list(:item, 2)
      create_list(:item, 3, :active)
      create_list(:item, 4, :sold)
      create_list(:item, 2, :expired)
      create_list(:item, 2, :sold, expired: true)
    end

    it "potential" do
      expect(Item.potential.count).to eq(2)
      Item.potential.each do |item|
        expect(item).to be_potential
      end
    end

    it "active" do
      expect(Item.active.count).to eq(5)
      Item.active.each do |item|
        expect(item).to be_active
      end
    end

    it "sold" do
      expect(Item.sold.count).to eq(6)
      Item.sold.each do |item|
        expect(item).to be_sold
      end
    end

    it "owned" do
      expect(Item.owned.count).to eq(5)
    end

    it "jtrp" do
      expect(Item.jtrp.count).to eq(11)
    end

    it "consigned" do
      create(:item, :active, client_intention: "consign")

      expect(Item.consigned.count).to eq(1)
    end

    it "for_sale" do
      create(:item, :active, client_intention: "consign")
      create(:item, :active, client_intention: "sell")

      expect(Item.for_sale.count).to eq(7)
    end

    context "amount due to client" do

      it "returns nil when item not sold" do
        item = build_stubbed(:item)
        expect(item.amount_due_to_client).to eq(nil)
      end

      it "returns nil when client intention not 'consign'" do
        item = build_stubbed(:item, :sold, client_intention: 'sell')
        expect(item.amount_due_to_client).to eq(nil)
      end

      it "calculates the correct amount due to client" do
        item = build_stubbed(:item, :sold, client_intention: 'consign', sale_price_cents: 1000)
        expect(item.amount_due_to_client).to eq(Money.new(500))
      end

      it "calculates the correct amount due to client when consignment rate not standard" do
        item = build_stubbed(:item, :sold, client_intention: 'consign', sale_price_cents: 1000, consignment_rate: 75)
        expect(item.amount_due_to_client).to eq(Money.new(250))
      end

      it "calculates the correct amount due to client when consignment rate 0" do
        item = build_stubbed(:item, :sold, client_intention: 'consign', sale_price_cents: 1000, consignment_rate: 0)
        expect(item.amount_due_to_client).to eq(Money.new(1000))
      end
    end

  end

  describe Item, "state_machine" do

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
      item = create(:item, proposal: proposal, client_intention: "sell")
      item.mark_active!

      expect(item).to be_active
    end

    it "syncs to clover when transitioning 'potential' to 'active'" do
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell", listing_price_cents: 5000)
      item.mark_active!

      expect(syncer).to have_received(:remote_create)
    end

    it "does not sync to clover when no listing price" do
      proposal = create(:proposal, :active)
      item = create(:item, proposal: proposal, client_intention: "sell")
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
      expect(item.agreement.reload).to be_inactive
      expect(syncer).to have_received(:remote_destroy)
    end

    it "does not transition 'active' to 'sold' when requirements not met" do
      item = create(:item, :active, client_intention: "sell")
      agreement = item.agreement
      agreement.status = "potential"
      agreement.save
      item.reload.mark_sold

      expect(item).not_to be_sold
      expect(item).to be_active
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
      item.mark_not_sold

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
      item = create(:item, proposal: proposal, client_intention: "sell")
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

  describe Item, "expired" do

    it "marks an item 'expired'" do
      now = DateTime.now
      Timecop.freeze(now)
      item = create(:item, :active, client_intention: "consign", listed_at: 91.days.ago)
      item.proposal.agreements.first.update_attribute("agreement_type", "consign")
      Timecop.return
      item.mark_expired

      expect(item).to be_expired
      expect(item.tag_list).to match_array(["expired"])
      expect(item.agreement).to be_inactive
    end

    it "does not mark an item 'expired' when requirements not met" do
      now = DateTime.now
      Timecop.freeze(now)
      item = create(:item, :active, client_intention: "consign", listed_at: 89.days.ago)
      Timecop.return
      item.mark_expired
      item.reload

      expect(item).not_to be_expired
      expect("expired").not_to be_in(item.tag_list)
      expect(item).to be_active
    end

  end

  it "remote_attributes" do
    item = create(:item)

    expect(item.remote_attributes).to eq({
      name: item.description,
      price: item.listing_price_cents,
      sku: item.id,
      alternateName: item.token,
      code: item.token
    }.to_json)
  end

  context 'amoeba' do

    let(:item) { create(:item, :active, :with_initial_photo, token: 'abc', remote_id: 'def') }

    it 'creates a child copy' do
      child_item = item.build_child_item
      child_item.save

      expect(item.children).to match_array([child_item])
      expect(child_item.token).not_to eq(item.token)
      expect(child_item.remote_id).not_to eq(item.remote_id)
      expect(child_item.description).to eq("Copy of #{item.description}")
    end

  end

end
