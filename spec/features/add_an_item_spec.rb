feature "add an item" do

  let(:category) { create(:category) }
  let(:user) { create(:internal_user) }

  context "guest" do
    scenario "visits category page" do
      visit category_path(category)

      expect(page).not_to have_link("New Item")
    end

    scenario "visits add an item page" do
      visit new_category_item_path(category)

      expect(page).not_to have_content(category.name)
      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits home page" do
      visit root_path

      expect(page).to have_link("Item")
    end

    scenario "clicks on 'Add an item' from home page" do
      visit root_path
      click_link("add Item")

      expect(page).to have_content("Add an item")
      expect(page).to have_field("Description")
      # expect(page).to have_field("item[initial_photos][]")

      expect(page).not_to have_content("Select Client")
      expect(page).not_to have_content("Select Category")
      expect(page).not_to have_field("Listing price")
      expect(page).not_to have_field("Purchase price")
      expect(page).not_to have_field("Minimum sale price")
      # expect(page).not_to have_field("item[listing_photos][]")
    end

  end

end
