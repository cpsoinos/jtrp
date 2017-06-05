feature "edit a category" do

  let(:user) { create(:internal_user) }
  let(:client) { create(:client) }
  let!(:category) { create(:category) }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits category show from index" do
      visit categories_path

      click_link(category.name, match: :first)
      expect(page).to have_link("edit")
    end

    scenario "visits edit category page from show" do
      visit category_path(category)
      within(".btn-group") do
        click_link("edit")
      end

      expect(page).to have_field("Name")
      expect(page).to have_button("Update Category")
      expect(page).to have_link("Cancel")
      expect(page).to have_link("Add a subcategory")
    end

    scenario "successfully updates a category" do
      visit edit_category_path(category)
      fill_in "Name", with: "Great Room"
      click_on("Update Category")

      expect(page).to have_content("Category updated!")
      expect(page).to have_content("Great Room")
    end

    scenario "adds a photo" do
      visit edit_category_path(category)
      attach_file("category[photo]", File.join(Rails.root, "/spec/fixtures/test_2.png"))
      click_button("Update Category")

      expect(page).to have_content("Category updated!")
      expect(category.photo).not_to be(nil)
    end

    scenario "tries to update a category by removing name" do
      visit edit_category_path(category)
      fill_in "Name", with: ""
      click_on("Update Category")

      expect(page).not_to have_content("Category updated!")
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Edit a Category")
      expect(page).to have_field("Name")
    end

    scenario "cancels updating a category" do
      visit edit_category_path(category)
      click_link("Cancel")

      expect(page).to have_content(category.name)
    end
  end

  context "guest" do

    scenario "visits categories page" do
      visit categories_path

      expect(page).not_to have_link("Edit")
    end

    scenario "visits edit category page" do
      visit edit_category_path(category)

      expect(page).to have_content("You must be logged in to access this page!")
    end

  end

  context "client" do

    before do
      sign_in client
    end

    scenario "visits categories page" do
      visit categories_path

      expect(page).not_to have_link("edit")
    end

    scenario "visits edit category page" do
      visit edit_category_path(category)

      expect(page).to have_content("Sorry, you don't have permission to access this page!")
    end

  end

end
