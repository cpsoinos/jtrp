feature "add a category" do

  let(:user) { create(:user, :internal) }
  let(:consignor) { create(:user, :consignor) }

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
  end

  context "guest" do
    scenario "visits categories page" do
      visit categories_path

      expect(page).not_to have_link("Add a category")
    end
  end

end
