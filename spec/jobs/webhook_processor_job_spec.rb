describe WebhookProcessorJob do

  let(:webhook) { create(:webhook, :locked_order) }
  let(:webhook_entries) { create_list(:webhook_entry, 5, webhook: webhook) }

  it "marks webhook entries processed" do
    webhook_entry = webhook_entries.first
    WebhookProcessorJob.perform_later

    webhook_entries.each do |entry|
      entry.reload
      expect(entry.processed?).to be(true)
    end
  end

  it "only tries to process unprocessed webhook entries" do
    processed_entries = create_list(:webhook_entry, 3, :open_order, :processed)
    processed_entries.each do |entry|
      order = create(:order)
      allow(order).to receive(:process_webhook)
      entry.webhookable = order
      entry.save
    end
    WebhookProcessorJob.perform_later

    processed_entries.each do |entry|
      expect(entry.webhookable).not_to have_received(:process_webhook)
    end
  end

  context "open order" do

    let(:webhook_entry) { create(:webhook_entry, :open_order) }

    it "does not error when calling 'process_webhook' on nil webhookable" do
      expect {
        WebhookProcessorJob.perform_later
      }.not_to raise_error
    end

  end

  context "locked order" do

    let!(:webhook_entry) { create(:webhook_entry, :locked_order) }
    let!(:order) { webhook_entry.webhookable }
    let(:updater) { double("updater") }

    before do
      allow(Order::Updater).to receive(:new).and_return(updater)
      allow(updater).to receive(:update)
    end

    it "calls 'process_webhook' on webhookable" do
      WebhookProcessorJob.perform_later

      expect(Order::Updater).to have_received(:new).with(order)
      expect(updater).to have_received(:update)
    end

  end

end
