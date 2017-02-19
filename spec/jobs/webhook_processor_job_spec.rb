describe WebhookProcessorJob do

  context "open order" do

    let(:webhook) { create(:webhook, :open_order) }

    it "does not create an order unless it has been locked in Clover", :vcr do
      expect {
        WebhookProcessorJob.perform_later(webhook)
      }.not_to change {
        Order.count
      }
    end

    it "only checks the remote order status once" do
      allow(Clover::Order).to receive(:find)
      WebhookProcessorJob.perform_later(webhook)

      expect(Clover::Order).to have_received(:find).once
    end

  end

  context "locked order" do

    let(:webhook) { create(:webhook, :locked_order) }

    it "creates a new order", :vcr do
      expect {
        WebhookProcessorJob.perform_later(webhook)
      }.to change {
        Order.count
      }.by(1)
    end

    it "checks all unique remote_objects for processability", :vcr do
      allow(Clover::Order).to receive(:find)
      WebhookProcessorJob.perform_later(webhook)

      expect(Clover::Order).to have_received(:find).twice
    end

  end

end
