shared_examples_for Streamable do

  let(:activity_feed_job) { double("activity_feed_job") }
  let(:klass) { described_class.to_s.underscore.to_sym }
  let(:object) { create(klass) }

  before do
    allow(ActivityFeedJob).to receive(:set).and_return(activity_feed_job)
    allow(activity_feed_job).to receive(:perform_later)
  end

  it "triggers an ActivityFeedJob" do
    expect(ActivityFeedJob).to receive(:set).with(wait: 1.second)
    expect(activity_feed_job).to receive(:perform_later).with(object)
    object.save
  end

end
