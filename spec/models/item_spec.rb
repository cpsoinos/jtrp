describe Item do

  it { should be_audited.associated_with(:proposal) }
  it { should belong_to(:category) }
  it { should belong_to(:proposal) }
  it { should belong_to(:order) }
  it { should have_many(:photos) }
  it { should have_one(:agreement_item) }
  it { should have_one(:agreement).through(:agreement_item) }
  it { should have_one(:statement_item) }
  it { should have_one(:statement).through(:statement_item) }

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

  context "scopes" do

    before :each do
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

  context "expired" do

    it "meets requirements expired" do
      Timecop.freeze(DateTime.now) do
        item = create(:item, :active, client_intention: "consign", listed_at: 91.days.ago)
        item.proposal.agreements.first.update_attribute("agreement_type", "consign")

        expect(item.meets_requirements_expired?).to be(true)
      end
    end

    it "does not meet requirements expired if client_intention is 'sell'" do
      Timecop.freeze(DateTime.now) do
        item = create(:item, :active, client_intention: "sell", listed_at: 91.days.ago)
        item.proposal.agreements.first.update_attribute("agreement_type", "sell")

        expect(item.meets_requirements_expired?).to be(false)
      end
    end

    it "does not meet requirements expired if listed_at is less than consignment period" do
      Timecop.freeze(DateTime.now) do
        item = create(:item, :active, client_intention: "consign", listed_at: 89.days.ago)
        item.proposal.agreements.first.update_attribute("agreement_type", "consign")

        expect(item.meets_requirements_expired?).to be(false)
      end
    end

    it "does not meet requirements expired if status is potential" do
      Timecop.freeze(DateTime.now) do
        item = create(:item, status: "potential", client_intention: "consign", listed_at: 91.days.ago)

        expect(item.meets_requirements_expired?).to be(false)
      end
    end

    it "does not meet requirements expired if status is sold" do
      Timecop.freeze(DateTime.now) do
        item = create(:item, :sold, client_intention: "consign", listed_at: 91.days.ago)
        item.proposal.agreements.first.update_attribute("agreement_type", "consign")

        expect(item.meets_requirements_expired?).to be(false)
      end
    end

    it "does not meet requirements expired if already expired" do
      Timecop.freeze(DateTime.now) do
        item = create(:item, :active, client_intention: "consign", listed_at: 91.days.ago, expired: true)
        item.tag_list << "expired"
        item.save
        item.proposal.agreements.first.update_attribute("agreement_type", "consign")

        expect(item.meets_requirements_expired?).to be(false)
      end
    end

    it "does not meet requirements expired if 'listed_at' not present" do
      item = create(:item, :active, client_intention: "consign", listed_at: nil)
      item.tag_list << "expired"
      item.save
      item.proposal.agreements.first.update_attribute("agreement_type", "consign")

      expect(item.meets_requirements_expired?).to be(false)
    end

    it "marks an item 'expired'" do
      now = DateTime.now
      Timecop.freeze(now)
      item = create(:item, :active, client_intention: "consign", listed_at: 91.days.ago)
      item.proposal.agreements.first.update_attribute("agreement_type", "consign")
      Timecop.return
      item.mark_expired

      expect(item).to be_expired
      expect(item.tag_list).to match_array(["expired"])
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
      name:          item.description,
      price:         item.listing_price_cents,
      sku:           item.id,
      alternateName: item.token,
      code:          item.token
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

  it "regenerates token before save to prevent collisions" do
    create(:item, description: "first item", token: "abc")
    new_item = build(:item, description: "second item", token: "abc")
    new_item.save

    expect(new_item.token).not_to eq("abc")
  end

  it "recalculates its association with an agreement when updated" do
    item = create(:item, :consigned, :active)
    item.update(client_intention: 'sell')

    expect(item.agreement.agreement_type).to eq('sell')
  end

end
