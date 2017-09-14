describe Category do

  it { should have_many(:items) }
  it { should have_many(:subcategories) }
  it { should belong_to(:parent) }

  it { should validate_presence_of(:name) }

  context "scopes" do

    let(:primary_categories) { Category.all }
    let!(:subcategories) { create_list(:category, 2, parent: primary_categories.first) }

    it "primary" do
      expect(Category.primary.count).to eq(4)
    end

    it "secondary" do
      expect(Category.secondary.count).to eq(2)

      subcategories.each do |subcategory|
        expect(subcategory.parent).to eq(primary_categories.first)
      end
    end

  end

  context "featured photo" do

    let(:category) { create(:category) }

    it "fetches an active item's featured photo" do
      item = create(:item, :with_listing_photo, :active, category: category)
      expect(category.featured_photo.model).to eq(item.featured_photo.photo.model)
    end

    it "falls back to its own photo when no active items with photos" do
      expect(category.featured_photo).to eq(category.photo)
    end

  end

end
