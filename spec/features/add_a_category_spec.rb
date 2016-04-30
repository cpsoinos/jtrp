feature "add a category" do

  let(:user) { create(:internal_user) }
  let(:client) { create(:client) }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits categories page" do
      visit categories_path

      expect(page).to have_link("Add a category")
    end

    scenario "clicks on 'Add a category' link" do
      visit categories_path

      click_link("Add a category")
      expect(page).to have_field("Name")
      expect(page).to have_field("Photo")
      expect(page).to have_content("optional")
      expect(page).to have_button("Create Category")
      expect(page).to have_link("Cancel")
    end

    scenario "successfully adds a category without a photo" do
      visit new_category_path
      fill_in "Name", with: "Great Room"
      click_on("Create Category")

      expect(page).to have_content("Category created!")
      expect(page).to have_content("Great Room")
      expect(page).to have_link("edit")
    end

    scenario "successfully adds a category with a photo" do
      visit new_category_path
      fill_in "Name", with: "Great Room"
      attach_file('category_photo', File.join(Rails.root, '/spec/fixtures/test.png'))
      click_on("Create Category")

      expect(page).to have_content("Category created!")
      expect(page).to have_content("Great Room")
      expect(page).to have_selector("img[src$='test.png']")
      expect(page).to have_link("edit")
    end

    scenario "unsuccessfully tries to add a category without a name" do
      visit new_category_path
      click_on("Create Category")

      expect(page).not_to have_content("Category created!")
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Add a Category")
      expect(page).to have_field("Name")
      expect(page).to have_field("Photo")
    end

    scenario "cancels adding a category" do
      visit new_category_path
      click_link("Cancel")

      expect(page).to have_link("Add a category")
    end
  end

  context "guest" do

    scenario "visits categories page" do
      visit categories_path

      expect(page).not_to have_link("Add a category")
    end

    scenario "visits new category page" do
      visit new_category_path

      expect(page).to have_content("Forbidden")
    end

  end

  context "client" do

    before do
      sign_in client
    end

    scenario "visits categories page" do
      visit categories_path

      expect(page).not_to have_link("Add a category")
    end

    scenario "visits new category page" do
      visit new_category_path

      expect(page).to have_content("Forbidden")
    end

  end

end
