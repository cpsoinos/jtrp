describe WebhookProcessorJob do

  let(:webhook) { create(:webhook) }
  let(:remote_order) do
    DeepStruct.wrap(
    {"href"=>"https://www.clover.com/v3/merchants/DEF456/orders/JKL987", "id"=>"JKL987", "currency"=>"USD", "employee"=>{"id"=>"QQYBQFPPQ8D0C"}, "total"=>51000, "taxRemoved"=>false, "isVat"=>false, "state"=>"locked", "manualTransaction"=>false, "groupLineItems"=>true, "testMode"=>false, "createdTime"=>1468069942000, "clientCreatedTime"=>1468069942000, "modifiedTime"=>1468074202000, "lineItems"=>{"elements"=>[{"id"=>"MNO654", "orderRef"=>{"id"=>"JKL987"}, "item"=>{"id"=>"MNO654"}, "name"=>"1 Small Stool", "price"=>1000, "printed"=>false, "createdTime"=>1468074064000, "orderClientCreatedTime"=>1468069942000, "exchanged"=>false, "refunded"=>false, "isRevenue"=>true}, {"id"=>"PQR432", "orderRef"=>{"id"=>"JKL987"}, "item"=>{"id"=>"PQR432"}, "name"=>"2 Identical Dressers", "price"=>35000, "printed"=>false, "createdTime"=>1468074148000, "orderClientCreatedTime"=>1468069942000, "exchanged"=>false, "refunded"=>false, "isRevenue"=>true}, {"id"=>"STU123", "orderRef"=>{"id"=>"PHM4QATAVKYDC"}, "item"=>{"id"=>"STU123"}, "name"=>"2 Overstuffed Chairs 1 Ottoman", "price"=>15000, "printed"=>false, "createdTime"=>1468074202000, "orderClientCreatedTime"=>1468069942000, "exchanged"=>false, "refunded"=>false, "isRevenue"=>true}]}, "device"=>{"id"=>"43fb2150-4593-4a67-a7c9-fb19325bded9"}}
    )
  end
  let!(:item1) { create(:item, :active, remote_id: "MNO654", listing_price_cents: 4000) }
  let!(:item2) { create(:item, :active, remote_id: "PQR432", listing_price_cents: 7000) }
  let!(:item3) { create(:item, :active, remote_id: "STU123", listing_price_cents: 40000) }
  let(:syncer) { double("syncer") }

  before do
    ENV["CLOVER_MERCHANT_ID"] = "DEF456"
    allow(Clover::Order).to receive(:find).and_return(remote_order)
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
    allow(syncer).to receive(:remote_destroy).and_return(true)
  end

  it "creates a new order when not existing" do
    expect {
      WebhookProcessorJob.perform_later(webhook)
    }.to change {
      Order.count
    }.by 1
  end

  it "updates and adds items to an existing order" do
    order = create(:order, remote_id: "JKL987")

    expect {
      WebhookProcessorJob.perform_later(webhook)
    }.to change {
      order.items.count
    }.by 3

    expect(order.reload.amount_cents).to eq(51000)
  end

  it "marks items as sold" do
    create(:order, remote_id: "JKL987")

    expect {
      WebhookProcessorJob.perform_later(webhook)
    }.to change {
      Item.sold.count
    }.by 3
  end

end
