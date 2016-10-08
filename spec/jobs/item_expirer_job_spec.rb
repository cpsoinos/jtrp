describe ItemExpirerJob do

  let!(:items) { create_list(:item, 3, :consigned, listed_at: 91.days.ago) }
  let(:item_ids) { items.map(&:id) }
  let(:expirer) { double('expirer') }

  before do
    allow(ItemExpirer).to receive(:new).and_return(expirer)
    allow(expirer).to receive(:expire!)
  end

  it "perform" do
    ItemExpirerJob.perform_later(item_ids)
    expect(expirer).to have_received(:expire!).with(items)
  end

end