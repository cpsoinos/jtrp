describe Item::Expirer do

  let(:items) { build_list(:item, 3, :consigned, listed_at: 91.days.ago) }

  it "can be instantiated" do
    expect(Item::Expirer.new).to be_an_instance_of(Item::Expirer)
  end

  it "calls 'mark_expired' on items" do
    allow_any_instance_of(Item).to receive(:mark_expired)
    Item::Expirer.new.expire!(items)

    items.each do |item|
      expect(item).to have_received(:mark_expired)
    end
  end

end
