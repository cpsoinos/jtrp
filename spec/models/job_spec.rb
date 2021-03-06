describe Job do

  it { should be_audited.associated_with(:account) }
  it { should belong_to(:account) }
  it { should have_many(:proposals) }
  it { should have_many(:items).through(:proposals) }
  it { should have_many(:agreements).through(:proposals) }

  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:address_1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }

  describe Job, "state_machine" do

    it "starts as 'potential'" do
      expect(Job.new).to be_potential
    end

    it "transitions 'potential' to 'active'" do
      job = create(:job)
      create(:proposal, :active, job: job)
      job.mark_active

      expect(job).to be_active
      expect(job.account).to be_active
    end

    it "transitions 'active' to 'completed'" do
      account = create(:account, :active)
      job = create(:job, :active, account: account)
      create(:proposal, :inactive, job: job)
      job.mark_completed

      expect(job).to be_completed
      expect(account).to be_inactive
    end

  end

  it "maps_url" do
    url = double("url")
    allow_any_instance_of(GeolocationService).to receive(:static_map_url).and_return(url)
    job = build_stubbed(:job)

    expect(job.maps_url).to eq(url)
  end

end
