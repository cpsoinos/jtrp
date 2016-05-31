describe Category do

  it { should have_many(:items) }
  it { should have_many(:subcategories) }
  it { should belong_to(:parent) }

  it { should validate_presence_of(:name) }

  context "scopes" do

    let!(:primary_categories) { create_list(:category, 3) }
    let!(:subcategories) { create_list(:category, 2, parent: primary_categories.first) }

    it "primary" do
      expect(Category.primary.count).to eq(3)
    end

    it "secondary" do
      expect(Category.secondary.count).to eq(2)
      
      subcategories.each do |subcategory|
        expect(subcategory.parent).to eq(primary_categories.first)
      end
    end

  end

end
