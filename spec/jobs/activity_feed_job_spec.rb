describe ActivityFeedJob do

  let!(:object) { create(:item) }
  let(:service) { double("service") }

  before do
    allow(ActivityFeedService).to receive(:new).with(object).and_return(service)
    allow(service).to receive(:post)
  end

  it "perform" do
    expect(ActivityFeedService).to receive(:new).with(object)
    expect(service).to receive(:post)
    ActivityFeedJob.perform_later(object)
  end

end
