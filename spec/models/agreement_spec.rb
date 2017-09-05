describe Agreement do

  it { should be_audited.associated_with(:proposal) }
  it { should belong_to(:proposal) }
  it { should have_one(:account).through(:job) }
  it { should have_many(:items).through(:proposal) }
  it { should have_many(:letters) }
  it { should belong_to(:created_by) }
  it { should belong_to(:updated_by) }

  describe "validations" do
    it { should validate_presence_of(:proposal) }
    it { should validate_presence_of(:agreement_type) }
  end

  before do
    allow(PdfGeneratorJob).to receive(:perform_later)
    allow(Notifier).to receive_message_chain(:send_agreement, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_agreement_active_notification, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_executed_agreement, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_agreement_pending_expiration, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_agreement_expired, :deliver_later)
  end

  describe "items" do
    let!(:agreement) { create(:agreement, :consign, :active) }
    let!(:proposal) { agreement.proposal }
    let!(:owned_items) { create_list(:item, 3, :owned, proposal: proposal) }
    let!(:consigned_items) { create_list(:item, 3, :consigned, proposal: proposal) }
    let!(:expired_items) { create_list(:item, 3, :expired, proposal: proposal) }

    it "has items that match its agreement_type" do
      consigned_items.each do |item|
        expect(item).to be_in(agreement.items)
      end
    end

    it "does not have items that do not match its agreement_type" do
      owned_items.each do |item|
        expect(item).not_to be_in(agreement.items)
      end
    end

    it "does not include expired items" do
      expired_items.each do |item|
        expect(item).not_to be_in(agreement.items)
      end
    end

    it "does not include an item's child items" do
      purchase_order = create(:agreement, :sell, :active, proposal: proposal)
      item = owned_items.first
      child = item.build_child_item
      child.save
      item.mark_inactive

      expect(purchase_order.items).to include(item)
      expect(purchase_order.items).not_to include(child)
    end

  end

  describe "scopes" do

    let!(:active_agreement) { create(:agreement, :active) }
    let!(:inactive_agreement) { create(:agreement, :inactive) }

    it "potential" do
      create(:agreement)

      expect(Agreement.potential.count).to eq(1)
    end

    it "active" do
      expect(Agreement.active.first).to eq(active_agreement)
    end

    it "inactive" do
      expect(Agreement.inactive.first).to eq(inactive_agreement)
    end

    it "unexpireable" do
      active_agreement.tag_list.add("unexpireable")
      active_agreement.save
      expect(Agreement.unexpireable).to match_array([active_agreement])
    end

    it "unexpireable" do
      active_agreement.tag_list.add("items_retrieved")
      active_agreement.save
      expect(Agreement.items_retrieved).to match_array([active_agreement])
    end

  end

  it "deletes cache after destroy" do
    agreement = create(:agreement)
    expect(agreement).to receive(:delete_cache)
    agreement.destroy
  end

end
