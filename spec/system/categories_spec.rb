describe "categories" do

  let!(:parent_category) { create(:category) }
  let!(:subcategory_a) { create(:category, parent: parent_category) }
  let!(:subcategory_b) { create(:category, parent: parent_category) }

  context "from landing page" do

    scenario "lists primary categories" do
      visit root_path

      expect(page).to have_link(parent_category.name.titleize)
      expect(page).not_to have_link("Uncategorized")
    end

    scenario "clicks into a category" do
      visit root_path
      click_link(parent_category.name)

      expect(page).to have_link("All #{parent_category.name}")
      expect(page).to have_link(subcategory_a.name)
      expect(page).to have_link(subcategory_b.name)
    end

  end

end
