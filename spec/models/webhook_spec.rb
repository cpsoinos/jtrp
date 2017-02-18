describe Webhook do

  let(:webhook) { build_stubbed(:webhook) }

  it 'objects' do
    expect(webhook.objects).to eq([{"ts"=>1468069677952, "type"=>"POST", "objectId"=>"O:JKL987"}])
  end

  it 'objects returns empty array when not from Clover app' do
    webhook = build_stubbed(:webhook, data: {"log": "admin\r", "pwd": "admin\r", "action": "receive", "format": "php", "controller": "webhooks", "testcookie": "1", "redirect_to": "https://www.jtrpfurniture.com/wp-admin/", "integration_name": "wp-login"})
    expect(webhook.objects).to eq([])
  end

end
