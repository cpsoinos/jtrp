describe LabelGenerator do

  let(:owned_item) { create(:item, :owned) }
  let(:consigned_item) { create(:item, :consigned) }
  let(:generator) { LabelGenerator.new([owned_item, consigned_item]) }

  it "can be instantiated" do
    expect(generator).to be_an_instance_of(LabelGenerator)
  end

  it "shows JTRP No. for owned items" do
    expect(generator.send(:show_client_name?, owned_item)).to be_falsey
  end

  it "shows JTRP No. for inactive owned items" do
    owned_item.mark_inactive
    expect(generator.send(:show_client_name?, owned_item)).to be_falsey
  end

  it "shows client name for consigned items" do
    expect(generator.send(:show_client_name?, consigned_item)).to be_truthy
  end

  it "shows client name for inactive consigned items" do
    consigned_item.mark_inactive
    expect(generator.send(:show_client_name?, consigned_item)).to be_truthy
  end

end
