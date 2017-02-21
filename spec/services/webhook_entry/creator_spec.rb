describe WebhookEntry::Creator do

  let(:webhook) { create(:webhook, :open_order) }
  let(:creator) { WebhookEntry::Creator.new(webhook) }
  let!(:order) { create(:order, remote_id: "RM0ZB8RSHYG58") }
  let(:attrs) { webhook.remote_entries.first }

  it "can be instantiated" do
    expect(creator).to be_an_instance_of(WebhookEntry::Creator)
  end

  it "creates a webhook_entry" do
    expect {
      creator.create(attrs)
    }.to change {
      WebhookEntry.count
    }.by(1)
  end

  it "properly sets attrs" do
    entry = creator.create(attrs)

    expect(entry.timestamp).to eq(Time.at(1487455480383/1000))
    expect(entry.action).to eq("UPDATE")
    expect(entry.webhookable).to eq(order)
  end

end
