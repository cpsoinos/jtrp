describe ActivityFeedService do

  let!(:user) { create(:internal_user) }
  let!(:object) { create(:client) }
  let(:audit) { object.audits.last }
  let(:service) { ActivityFeedService.new(object) }
  let(:feed) { double("feed") }
  let(:activity_data) do
    {
      actor: "user:#{user.id}",
      verb: audit.action,
      object: "User:#{object.id}",
      time: audit.created_at.iso8601,
      to: ["timeline:jtrp"],
      foreign_id: audit.id
    }
  end

  before do
    audit.user = user
    audit.save
    allow(service).to receive(:feed).and_return(feed)
    allow(feed).to receive(:add_activity)
  end

  it "can be instantiated" do
    expect(service).to be_an_instance_of(ActivityFeedService)
  end

  it "posts to a user's activity feed" do
    allow(service).to receive(:post).and_call_original
    service.post
    expect(feed).to have_received(:add_activity).with(activity_data)
  end

end
