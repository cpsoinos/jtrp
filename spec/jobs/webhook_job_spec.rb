describe WebhookJob do

  let(:creator) { double("creator") }

  before do
    allow(Webhooks::Creator).to receive(:new).and_return(creator)
    allow(creator).to receive(:create)
  end

  it "calls Webhooks::Creator" do
    WebhookJob.perform_later("clover", { data: "data" })

    expect(Webhooks::Creator).to have_received(:new).with("clover", { data: "data" })
    expect(creator).to have_received(:create)
  end

end
