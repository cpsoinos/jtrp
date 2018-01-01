describe ItemExpirerJob do

  let(:items) { create_list(:item, 3, :consigned, listed_at: 91.days.ago) }
  let(:expirer) { double('expirer') }

  before do
    allow(Items::Expirer).to receive(:new).and_return(expirer)
    allow(expirer).to receive(:execute)
  end

  it "perform" do
    ItemExpirerJob.perform_later(items.pluck(:id))

    expect(Items::Expirer).to have_received(:new).with(items)
    expect(expirer).to have_received(:execute)
  end

end
