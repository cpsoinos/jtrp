# feature "add a category" do
#
#   let(:user) { create(:internal_user) }
#   let(:client) { create(:client) }
#
#   context "internal user" do
#
#     before do
#       sign_in user
#     end
#
#     scenario "visits categories page" do
#       visit categories_path
#
#       expect(page).to have_link("Add a category")
#     end
#
#     scenario "clicks on 'Add a category' link" do
#       visit categories_path
#
#       click_link("Add a category")
#       expect(page).to have_field("Name")
#       expect(page).to have_button("Create Category")
#       expect(page).to have_link("Cancel")
#     end
#
#     scenario "successfully adds a category" do
#       visit new_category_path
#       fill_in "Name", with: "Great Room"
#       click_on("Create Category")
#
#       expect(page).to have_content("Category created!")
#       expect(page).to have_content("Great Room")
#     end
#
#     scenario "unsuccessfully tries to add a category without a name" do
#       visit new_category_path
#       click_on("Create Category")
#
#       expect(page).not_to have_content("Category created!")
#       expect(page).to have_content("Name can't be blank")
#       expect(page).to have_content("Add a Category")
#       expect(page).to have_field("Name")
#     end
#
#     scenario "cancels adding a category" do
#       visit new_category_path
#       click_link("Cancel")
#
#       expect(page).to have_link("Add a category")
#     end
#
#     scenario "adds a subcategory" do
#       category = create(:category, name: "Aquarium")
#       visit category_path(category)
#       click_link("Add a subcategory")
#
#       expect(page).to have_field("Name")
#       expect(page).to have_button("Create Category")
#       expect(page).to have_link("Cancel")
#
#       fill_in("Name", with: "Accessories")
#       click_on("Create Category")
#
#       expect(page).to have_content("Category created!")
#       expect(page).to have_link("Accessories")
#     end
#
#   end
#
#   context "guest" do
#
#     scenario "visits categories page" do
#       visit categories_path
#
#       expect(page).not_to have_link("Add a category")
#     end
#
#     scenario "visits new category page" do
#       visit new_category_path
#
#       expect(page).to have_content("You must be logged in to access this page")
#     end
#
#   end
#
#   context "client" do
#
#     before do
#       sign_in client
#     end
#
#     scenario "visits categories page" do
#       visit categories_path
#
#       expect(page).not_to have_link("Add a category")
#     end
#
#     scenario "visits new category page" do
#       visit new_category_path
#
#       expect(page).to have_content("You must be logged in to access this page")
#     end
#
#   end
#
# end
