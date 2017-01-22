feature "categories" do

  let!(:parent_category) { create(:category) }
  let!(:subcategory_a) { create(:category, parent: parent_category) }
  let!(:subcategory_b) { create(:category, parent: parent_category) }

  context "from landing page" do

    scenario "lists primary categories", js: true do
      visit root_path

      within(".left-menu") do
        expect(page).to have_link(parent_category.name)
        expect(page).to have_link(subcategory_a.name, visible: false)
        expect(page).to have_link(subcategory_b.name, visible: false)
      end
    end

    scenario "expands primary categories to show subcategories", js: true do
      visit root_path

      within(".left-menu") do
        click_link(parent_category.name)
        expect(page).to have_link("All #{parent_category.name}")
        expect(page).to have_link(subcategory_a.name)
        expect(page).to have_link(subcategory_b.name)
      end
    end

    scenario "clicks into a category", js: true do
      visit root_path

      within(".left-menu") do
        click_link(parent_category.name)
        click_link("All #{parent_category.name}")

        expect(page).to have_link("All #{parent_category.name}")
        expect(page).to have_link(subcategory_a.name)
        expect(page).to have_link(subcategory_b.name)
      end

      within(".cat_header") do
        expect(page).to have_content(parent_category.name.upcase)
      end
    end

  end

  context "from within a category" do

    scenario "expands selected primary category to show subcategories", js: true do
      visit category_path(parent_category)

      within(".left-menu") do
        expect(page).to have_link(parent_category.name)
        expect(page).to have_link("All #{parent_category.name}")
        expect(page).to have_link(subcategory_a.name)
        expect(page).to have_link(subcategory_b.name)
      end
    end

  end

end
