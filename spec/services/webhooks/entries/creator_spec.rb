module Webhooks
  module Entries
    describe Creator do

      let(:webhook) { create(:webhook, :open_order) }
      let(:remote_entry) { webhook.remote_entries.first }
      let(:creator) { Webhooks::Entries::Creator.new(webhook, remote_entry) }
      let!(:order) { create(:order, remote_id: "RM0ZB8RSHYG58") }

      before do
        allow_any_instance_of(Webhook).to receive(:create_webhook_entries)
      end

      it "can be instantiated" do
        expect(creator).to be_an_instance_of(Webhooks::Entries::Creator)
      end

      it "creates a webhook_entry" do
        expect {
          creator.create
        }.to change {
          WebhookEntry.count
        }.by(1)
      end

      it "properly sets attrs" do
        entry = creator.create

        expect(entry.timestamp).to eq(Time.at(1487455480383/1000))
        expect(entry.action).to eq("UPDATE")
        expect(entry.webhookable).to eq(order)
      end

    end
  end
end
