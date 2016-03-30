feature "add an item" do

  let(:category) { create(:category) }
  let(:admin) { create(:user, :admin) }

  context "guest" do
    scenario "visits category page" do
      visit category_path(category)

      expect(page).not_to have_link("Add an item")
    end

    scenario "visits add an item page" do
      visit new_category_item_path(category)

      expect(page).not_to have_content(category.name)
      expect(page).to have_content("Forbidden")
    end
  end

  context "owner" do
    scenario "visits category page" do
      sign_in admin
      visit category_path(category)

      expect(page).to have_link("Add an item")
    end

    scenario "clicks on add item link" do
      sign_in admin
      visit category_path(category)
      click_on "Add an item"

      expect(page).to have_content(category.name)
      expect(page).to have_content("Add an item")
    end

    scenario "successfully adds an item" do
      sign_in admin
      visit new_category_item_path(category)

      attach_file('item_photos', File.join(Rails.root, '/spec/fixtures/test.png'))
      fill_in "Name", with: "Chair"
      fill_in "Description", with: "People sit in it."
      click_on("Create Item")

      expect(page).to have_content("Item created")
      expect(page).to have_content("Chair")
      expect(page).to have_content("People sit in it.")
      expect(page).to have_selector("img[src$='test.png']")
    end

    scenario "unsuccessfully adds an item" do
      sign_in admin
      visit new_category_item_path(category)

      fill_in "Description", with: "People sit in it."
      click_on("Create Item")

      expect(page).to have_content("Item could not be saved")
    end
  end

end
