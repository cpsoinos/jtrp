feature "add an item" do

  let(:category) { create(:category) }
  let(:user) { create(:internal_user) }

  context "guest" do
    scenario "visits category page" do
      visit category_path(category)

      expect(page).not_to have_link("Quick-Add Item")
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

      expect(page).to have_link("Quick-Add Item")
    end

    scenario "clicks on 'Add an item' from home page" do
      visit root_path
      click_link("Quick-Add Item")

      expect(page).to have_content("Add an item")
      expect(page).to have_field("Name")
      expect(page).to have_field("Description")
      expect(page).to have_field("initial_photos[]")

      expect(page).not_to have_content("Select Client")
      expect(page).not_to have_content("Select Category")
      expect(page).not_to have_field("Listing price")
      expect(page).not_to have_field("Purchase price")
      expect(page).not_to have_field("Minimum sale price")
      expect(page).not_to have_field("Condition")
      expect(page).not_to have_field("listing_photos[]")
    end

    scenario "successfully adds an uncategorized item" do
      visit new_item_path

      attach_file('initial_photos[]', File.join(Rails.root, '/spec/fixtures/test.png'))
      fill_in "Name", with: "Chair"
      fill_in "Description", with: "People sit in it."
      click_on("Add Item")

      expect(page).to have_content("Item created")
      expect(page).to have_content("Chair")
      expect(page).to have_content("People sit in it.")
      expect(page).to have_css("img[src*='test.png']")
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

      expect(page).not_to have_content("Select Client")
      expect(page).not_to have_content("Select Category")
      expect(page).not_to have_field("Listing price")
      expect(page).not_to have_field("Purchase price")
      expect(page).not_to have_field("Minimum sale price")
      expect(page).not_to have_field("Condition")
      expect(page).not_to have_field("listing_photos[]")
    end

    scenario "successfully adds an item" do
      visit new_category_item_path(category)

      attach_file('initial_photos[]', File.join(Rails.root, '/spec/fixtures/test.png'))
      fill_in "Name", with: "Chair"
      fill_in "Description", with: "People sit in it."
      click_on("Add Item")

      expect(page).to have_content("Item created")
      expect(page).to have_content("Chair")
      expect(page).to have_content("People sit in it.")
      expect(page).to have_css("img[src*='test.png']")
    end

    scenario "unsuccessfully adds an item" do
      visit new_category_item_path(category)
      fill_in "Description", with: "People sit in it."
      click_on("Add Item")

      expect(page).to have_content("Item could not be saved")
    end
  end

end
