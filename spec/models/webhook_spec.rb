describe Webhook do

  it { should have_many(:webhook_entries) }

  let(:webhook) { build_stubbed(:webhook, :open_order) }

  it 'remote_entries' do
    expect(webhook.remote_entries).to match_array([{"ts" => 1487455480383, "type" => "UPDATE", "objectId" => "O:RM0ZB8RSHYG58"}, {"ts" => 1487455480998, "type" => "UPDATE", "objectId" => "O:RM0ZB8RSHYG58"}])
  end

  it 'remote_entries returns empty array when not from Clover app' do
    webhook = build_stubbed(:webhook, data: {"log": "admin\r", "pwd": "admin\r", "action": "receive", "format": "php", "controller": "webhooks", "testcookie": "1", "redirect_to": "https://www.jtrpfurniture.com/wp-admin/", "integration_name": "wp-login"})
    expect(webhook.remote_entries).to eq([])
  end

end
