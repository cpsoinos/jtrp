describe Photo do

  it { should validate_presence_of(:photo_type) }
  it do |photo|
    should validate_uniqueness_of(:photo_type).scoped_to(:item_id).with_message("one featured photo per item") if photo.featured?
  end

  describe "scopes" do

    let!(:initial_photos) { create_list(:photo, 2, :initial) }
    let!(:listing_photos) { create_list(:photo, 2, :listing) }
    let!(:featured_photos) { create_list(:photo, 2, :featured) }

    it "initial" do
      expect(Photo.initial).to eq(initial_photos)
    end

    it "listing" do
      expect(Photo.listing).to eq(listing_photos)
    end

    it "listing" do
      expect(Photo.featured).to eq(featured_photos)
    end

  end

end
