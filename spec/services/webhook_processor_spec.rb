describe WebhookProcessor do

  let(:data) { {"key": "value"} }
  let(:processor) { WebhookProcessor.new(data) }

  before do
    allow(WebhookProcessorJob).to receive(:perform_later)
  end

  it "can be instantiated" do
    expect(processor).to be_an_instance_of(WebhookProcessor)
  end

  it "calls WebhookProcessorJob" do
    processor.process
    expect(WebhookProcessorJob).to have_received(:perform_later)
  end

  it "creates a webhook object" do
    expect {
      processor.process
    }.to change {
      Webhook.count
    }.by 1
  end

end
