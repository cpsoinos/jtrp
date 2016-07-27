describe Order do

  it { should have_many(:items) }

  describe "#process_webhook" do

    let(:order) { create(:order) }
    let(:webhook) { create(:webhook) }
    let(:remote_order) { double("remote_order") }

    before do
      allow(Clover::Order).to receive(:find).with(order).and_return(remote_order)
      allow(remote_order).to receive(:total).and_return(1234)
      allow(remote_order).to receive(:createdTime).and_return(4567)
      allow(remote_order).to receive(:modifiedTime).and_return(8963)
    end

    it "updates order price from webhook" do
      order.process_webhook
      expect(order.amount_cents).to eq(1234)
    end


  end

end
