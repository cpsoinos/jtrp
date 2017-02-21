describe WebhookEntry do

  it { should belong_to(:webhook) }
  it { should belong_to(:webhookable) }

  let(:webhook_entry) { build_stubbed(:webhook_entry) }

  it "#process" do
    allow(WebhookProcessorJob).to receive(:perform_later)
    webhook_entry.process

    expect(WebhookProcessorJob).to have_received(:perform_later).with(webhook_entry)
  end

end
