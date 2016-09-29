describe Photo do

  it { should be_audited.associated_with(:item) }

  it { should belong_to(:item) }
  it { should belong_to(:proposal) }
  it { should validate_presence_of(:photo_type) }

  describe "scopes" do

    let!(:initial_photos) { create_list(:photo, 2, :initial) }
    let!(:listing_photos) { create_list(:photo, 2, :listing) }

    it "initial" do
      expect(Photo.initial).to eq(initial_photos)
    end

    it "listing" do
      expect(Photo.listing).to eq(listing_photos)
    end

  end

end
