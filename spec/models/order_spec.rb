describe Order do

  it { should have_many(:items) }

  describe "#process_webhook" do

    let(:order) { create(:order) }
    let(:webhook) { create(:webhook) }
    let(:remote_order) { double("remote_order") }
    let(:line_items) { double("line_items") }
    let(:elements) { DeepStruct.wrap([{item: {id: "1234"}, name: "some name"}, {name: "Manual Transaction"}]) }

    before do
      allow(Clover::Order).to receive(:find).with(order).and_return(remote_order)
      allow(remote_order).to receive(:lineItems).and_return(line_items)
      allow(line_items).to receive(:elements).and_return(elements)
      allow(remote_order).to receive(:total).and_return(1234)
      allow(remote_order).to receive(:createdTime).and_return(4567)
      allow(remote_order).to receive(:modifiedTime).and_return(8963)
    end

    it "updates order price from webhook" do
      order.process_webhook
      expect(order.amount_cents).to eq(1234)
    end

    it "calculates thirty day revenue" do
      orders = create_list(:order, 3, created_at: 5.days.ago, amount_cents: 5000)
      expect(Order.thirty_day_revenue).to eq(150)
    end

    it "does not include older orders in thirty day revenue" do
      create(:order, amount_cents: 5000, created_at: 40.days.ago)
      orders = create_list(:order, 3, created_at: 5.days.ago, amount_cents: 5000)
      expect(Order.thirty_day_revenue).to eq(150)
    end

  end

end
