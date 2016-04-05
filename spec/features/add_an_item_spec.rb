feature "add an item" do

  let(:category) { create(:category) }
  let(:user) { create(:user, :internal) }

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

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits home page" do
      visit root_path

      expect(page).to have_link("Add an item")
    end

    scenario "visits category page" do
      visit category_path(category)

      expect(page).to have_link("Add an item")
    end

    scenario "clicks on add item link" do
      visit category_path(category)
      click_on "Add an item"

      expect(page).to have_content(category.name)
      expect(page).to have_content("Add an item")
      expect(page).to have_field("Name")
      expect(page).to have_field("Description")
      expect(page).to have_field("Purchase price")
      expect(page).to have_field("Listing price")
    end

    scenario "successfully adds an item" do
      visit new_category_item_path(category)

      attach_file('item_initial_photos', File.join(Rails.root, '/spec/fixtures/test.png'))
      fill_in "Name", with: "Chair"
      fill_in "Description", with: "People sit in it."
      click_on("Add Item")

      expect(page).to have_content("Item created")
      expect(page).to have_content("Chair")
      expect(page).to have_content("People sit in it.")
      expect(page).to have_selector("img[src$='test.png']")
    end

    scenario "unsuccessfully adds an item" do
      visit new_category_item_path(category)

      fill_in "Description", with: "People sit in it."
      click_on("Add Item")

      expect(page).to have_content("Item could not be saved")
    end
  end

end
