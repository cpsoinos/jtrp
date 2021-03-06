describe Statement do

  it { should be_audited.associated_with(:account) }
  it { should belong_to(:account) }
  it { should have_many(:statement_items) }
  it { should have_many(:checks) }
  it { should have_many(:items).through(:statement_items) }

  context "state machine" do

    let(:sender) { double("sender") }

    it "starts as 'unpaid'" do
      expect(Statement.new(account: build_stubbed(:account))).to be_unpaid
    end

    it "transitions 'unpaid' to 'paid'" do
      statement = create(:statement)
      allow(Checks::Sender).to receive(:new).and_return(sender)
      allow(sender).to receive(:send_check)
      expect(statement).to be_unpaid
      statement.pay
      expect(statement.reload).to be_paid
    end

  end

  context "items" do
    let(:agreement) { create(:agreement, :active, :consign) }
    let(:account) { agreement.account }
    let(:items) { create_list(:item, 5, :sold, sale_price_cents: 5000, client_intention: 'consign', proposal: agreement.proposal) }
    let(:older_item) { create(:item, :sold, sale_price_cents: 7000, client_intention: 'consign', proposal: agreement.proposal, sold_at: 45.days.ago) }
    let(:expired_item) { create(:item, :sold, proposal: agreement.proposal, listed_at: 91.days.ago) }
    let(:statement) { create(:statement, account: account) }

    before do
      Timecop.freeze("October 1, 2016")
      day_incrementer = 1
      items.map do |item|
        item.sold_at = day_incrementer.days.ago
        item.save
        day_incrementer += 1
      end
      Statements::ItemGatherer.new(statement, account).execute
    end

    after do
      Timecop.return
    end

    it "returns items from the account sold within the past month" do
      statement.items.each do |item|
        expect(item.in?(items)).to be(true)
        expect(item.sold_at > statement.send(:starting_date)).to be(true)
        expect(item.sold_at < statement.send(:ending_date)).to be(true)
      end
    end

    it "does not include items from the account sold more than a month ago" do
      expect(statement.items).not_to include(older_item)
    end

    it "does not include expired items" do
      expect(statement.items).not_to include(expired_item)
    end

    it "calculates the total consignment fee" do
      expect(statement.total_consignment_fee).to eq(Money.new(12500))
    end

    it "calculates the amount due to client" do
      expect(statement.amount_due_to_client).to eq(Money.new(12500))
    end

    it "calculates the amount due to client when parts and labor included on items" do
      items.first.update_attributes(parts_cost_cents: 300, labor_cost_cents: 200)
      expect(statement.amount_due_to_client).to eq(Money.new(12000))
    end

    it "calculates the total consignment fee when consignment rates aren't consistent" do
      items.last.update_attribute("consignment_rate", 65)
      expect(statement.total_consignment_fee).to eq(Money.new(13250))
    end

    it "calculates the total amount due to client when consignment rates aren't consistent" do
      items.last.update_attribute("consignment_rate", 65)
      expect(statement.amount_due_to_client).to eq(Money.new(11750))
    end

    it "calculates the total sales for the month" do
      expect(statement.total_sales).to eq(Money.new(25000))
    end

  end

  it "object_url" do
    statement = create(:statement)

    expect(statement.object_url).to eq("#{ENV['HOST']}/accounts/#{statement.account.slug}/statements/#{statement.id}?token=#{statement.token}")
  end

  context "unpaid" do
    it "task" do
      statement = create(:statement)

      expect(statement.task).to eq({ name: "pay statement", description: "needs to be paid and sent to the client" })
    end
  end

  context "paid" do
    it "task" do
      statement = create(:statement, :paid, check_number: nil)

      expect(statement.task).to eq({ name: "record check number", description: "needs a check number recorded", task_field: :check_number })
    end
  end

end
