module Webhooks
  describe Creator do

    let(:integration) { "clover" }
    let(:data) { "abc" }
    let(:creator) { Webhooks::Creator.new(integration, data) }

    it "can be instantiated" do
      expect(creator).to be_an_instance_of(Webhooks::Creator)
    end

    it "creates a webhook" do
      expect {
        creator.create
      }.to change {
        Webhook.count
      }.by(1)
    end

  end
end
