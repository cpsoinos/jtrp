describe Statement do

  it_should_behave_like Streamable

  it { should be_audited.associated_with(:agreement) }
  it { should belong_to(:agreement) }

  describe "state machine" do

    it "starts as 'unpaid'" do
      expect(Statement.new(agreement: build_stubbed(:agreement))).to be_unpaid
    end

    it "transitions 'unpaid' to 'paid'" do
      statement = create(:statement)
      expect(statement).to be_unpaid
      statement.pay
      expect(statement.reload).to be_paid
    end

  end

  describe "items" do
    let(:agreement) { create(:agreement, :active, :consign) }
    let(:items) { create_list(:item, 5, :sold, sale_price_cents: 5000, client_intention: 'consign', proposal: agreement.proposal) }
    let(:older_item) { create(:item, :sold, sale_price_cents: 7000, client_intention: 'consign', proposal: agreement.proposal, sold_at: 45.days.ago) }
    let(:statement) { create(:statement, agreement: agreement) }

    before do
      day_incrementer = 1
      items.map do |item|
        item.sold_at = day_incrementer.days.ago
        item.save
        day_incrementer += 1
      end
    end

    it "returns items from the agreement sold within the past month" do
      expect(statement.items).to eq(items.sort_by(&:sold_at))
    end

    it "does not include items from the agreement sold more than a month ago" do
      expect(statement.items).not_to include(older_item)
    end

    it "calculates the total consignment fee" do
      expect(statement.total_consignment_fee).to eq(125)
    end

    it "calculates the amount due to client" do
      expect(statement.amount_due_to_client).to eq(125)
    end

    it "calculates the total consignment fee when consignment rates aren't consistent" do
      items.last.update_attribute("consignment_rate", 65)
      expect(statement.total_consignment_fee).to eq(132.5)
    end

    it "calculates the total amount due to client when consignment rates aren't consistent" do
      items.last.update_attribute("consignment_rate", 65)
      expect(statement.amount_due_to_client).to eq(117.5)
    end

  end

  it "object_url" do
    statement = create(:statement)

    expect(statement.object_url).to eq("#{ENV['HOST']}/accounts/#{statement.account.slug}/statements/#{statement.id}")
  end

end
