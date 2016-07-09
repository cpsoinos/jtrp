describe WebhookProcessor do

  let(:data) {
    {"appId"=>"ABC123", "merchants"=>{"DEF456"=>[{"ts"=>1468069677952, "type"=>"POST", "objectId"=>"O:JKL987"}]}}
  }
  let(:processor) { WebhookProcessor.new(data) }

  let(:remote_order) do
    DeepStruct.wrap(
    {"href"=>"https://www.clover.com/v3/merchants/DEF456/orders/JKL987", "id"=>"JKL987", "currency"=>"USD", "employee"=>{"id"=>"QQYBQFPPQ8D0C"}, "total"=>51000, "taxRemoved"=>false, "isVat"=>false, "state"=>"open", "manualTransaction"=>false, "groupLineItems"=>true, "testMode"=>false, "createdTime"=>1468069942000, "clientCreatedTime"=>1468069942000, "modifiedTime"=>1468074202000, "lineItems"=>{"elements"=>[{"id"=>"MNO654", "orderRef"=>{"id"=>"JKL987"}, "item"=>{"id"=>"MNO654"}, "name"=>"1 Small Stool", "price"=>1000, "printed"=>false, "createdTime"=>1468074064000, "orderClientCreatedTime"=>1468069942000, "exchanged"=>false, "refunded"=>false, "isRevenue"=>true}, {"id"=>"PQR432", "orderRef"=>{"id"=>"JKL987"}, "item"=>{"id"=>"PQR432"}, "name"=>"2 Identical Dressers", "price"=>35000, "printed"=>false, "createdTime"=>1468074148000, "orderClientCreatedTime"=>1468069942000, "exchanged"=>false, "refunded"=>false, "isRevenue"=>true}, {"id"=>"STU123", "orderRef"=>{"id"=>"PHM4QATAVKYDC"}, "item"=>{"id"=>"STU123"}, "name"=>"2 Overstuffed Chairs 1 Ottoman", "price"=>15000, "printed"=>false, "createdTime"=>1468074202000, "orderClientCreatedTime"=>1468069942000, "exchanged"=>false, "refunded"=>false, "isRevenue"=>true}]}, "device"=>{"id"=>"43fb2150-4593-4a67-a7c9-fb19325bded9"}}
    )
  end

  before do
    ENV["CLOVER_MERCHANT_ID"] = "DEF456"
    allow(Clover::Order).to receive(:find).and_return(remote_order)
  end

  it "can be instantiated" do
    expect(processor).to be_an_instance_of(WebhookProcessor)
  end

  it "creates a webhook object" do
    expect {
      processor.process
    }.to change {
      Webhook.count
    }.by 1
  end

  it "creates a new order when not existing" do
    expect {
      processor.process
    }.to change {
      Order.count
    }.by 1
  end

  it "updates and adds items to an existing order" do
    order = create(:order, remote_id: "JKL987")
    item = create(:item, :active, remote_id: "MNO654")
    item = create(:item, :active, remote_id: "PQR432")
    item = create(:item, :active, remote_id: "STU123")

    expect {
      processor.process
    }.to change {
      order.items.count
    }.by 3

    expect(order.reload.amount_cents).to eq(51000)
  end

end
