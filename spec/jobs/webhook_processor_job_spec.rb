describe WebhookProcessorJob do

  context "open order" do

    let(:webhook_entry) { create(:webhook_entry, :open_order) }

    it "does not error when calling 'process_webhook' on nil webhookable" do
      expect {
        WebhookProcessorJob.perform_later(webhook_entry)
      }.not_to raise_error
    end

  end

  context "locked order" do

    let(:webhook_entry) { create(:webhook_entry, :locked_order) }
    let(:order) { webhook_entry.webhookable }
    let(:updater) { double("updater") }

    before do
      allow(Order::Updater).to receive(:new).and_return(updater)
      allow(updater).to receive(:update)
    end

    it "calls 'process_webhook' on webhookable" do
      WebhookProcessorJob.perform_later(webhook_entry)

      expect(Order::Updater).to have_received(:new).with(order)
      expect(updater).to have_received(:update)
    end

    it "does not call 'process_webhook' when local object not changed" do
      order.update_attributes(updated_at: webhook_entry.timestamp)
      WebhookProcessorJob.perform_later(webhook_entry)

      expect(Order::Updater).not_to have_received(:new)
    end

  end

end
