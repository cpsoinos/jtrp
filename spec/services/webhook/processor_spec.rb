describe Webhook::Processor do

  let(:data) { {"key": "value"} }
  let(:processor) { Webhook::Processor.new('clover', data) }

  before do
    allow(WebhookProcessorJob).to receive(:perform_later)
  end

  it "can be instantiated" do
    expect(processor).to be_an_instance_of(Webhook::Processor)
  end

  it "creates a webhook" do
    expect {
      processor.process
    }.to change {
      Webhook.count
    }.by(1)
  end

  it "creates webhook entries" do
    webhook = create(:webhook, :open_order)
    expect {
      Webhook::Processor.new('clover', webhook.data).process
    }.to change {
      WebhookEntry.count
    }.by(2)
  end

  it "processes webhook entries" do
    allow_any_instance_of(WebhookEntry).to receive(:process)
    webhook = create(:webhook, :open_order)
    Webhook::Processor.new('clover', webhook.data).process

    webhook.webhook_entries.each do |entry|
      expect(entry).to have_received(:process)
    end
  end

end
