module Items
  describe Creator do

    let(:user) { create(:internal_user) }
    let(:proposal) { create(:proposal) }
    let(:account) { proposal.account }
    let(:attrs) { attributes_for(:item) }
    let(:initial_photo_attrs) { attributes_for(:photo) }
    let(:listing_photo_attrs) { attributes_for(:photo, :listing) }

    it "can be instantiated" do
      expect(Items::Creator.new(proposal)).to be_an_instance_of(Items::Creator)
    end

    it "creates an item" do
      expect {
        Items::Creator.new(proposal).create(attrs)
      }.to change {
        Item.count
      }.by (1)
    end

    it "sets category to Uncategorized unless specified" do
      expect(Items::Creator.new(proposal).create(attrs).category.name).to eq("Uncategorized")
    end

    it "sets the account_item_number" do
      item = Items::Creator.new(proposal).create(attrs)
      expect(item.account_item_number).to eq(1)
    end

    it "correctly sequences account_item_number over a second proposal" do
      item_1 = Items::Creator.new(proposal).create(attrs)
      proposal_2 = create(:proposal, job: proposal.job)
      item_2 = Items::Creator.new(proposal_2).create(description: "second item", client_intention: "sell")

      expect(item_1.account_item_number).to eq(1)
      expect(item_2.account_item_number).to eq(2)
    end

    it "correctly sequences account_item_number over a second job" do
      item_1 = Items::Creator.new(proposal).create(attrs)
      proposal_2 = create(:proposal, job: create(:job, account: account))
      item_2 = Items::Creator.new(proposal_2).create(description: "second item", client_intention: "sell")

      expect(item_1.account_item_number).to eq(1)
      expect(item_2.account_item_number).to eq(2)
    end

    it "processes photos" do
      pending("image selector specs")
      attrs[:initial_photos] = [initial_photo_attrs]
      attrs[:listing_photos] = [listing_photo_attrs]
      item = Items::Creator.new(proposal).create(attrs)

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
        item = Items::Creator.new(proposal).create(attrs)

        expect(item.parent_item).to eq(parent_item)
      end

      it "deactivates a parent item when creating a child item" do
        Items::Creator.new(proposal).create(attrs)

        expect(parent_item.reload).to be_inactive
      end

    end

  end
end
