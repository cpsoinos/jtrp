describe WebhookEntry do

  it { should belong_to(:webhook) }
  it { should belong_to(:webhookable) }

  let(:webhook_entry) { build_stubbed(:webhook_entry) }

  it 'validates processed' do
    expect(webhook_entry).to validate_inclusion_of(:processed).in_array([true, false])
  end

  context "scopes" do
    it "processed" do
      processed = create_list(:webhook_entry, 3, :processed)
      create(:webhook_entry)

      expect(WebhookEntry.processed).to match_array(processed)
    end

    it "unprocessed" do
      unprocessed = create_list(:webhook_entry, 3, :unprocessed)
      create(:webhook_entry, :processed)

      expect(WebhookEntry.unprocessed).to match_array(unprocessed)
    end
  end

end
