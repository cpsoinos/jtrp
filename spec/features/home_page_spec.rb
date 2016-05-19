feature "home page" do

  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let(:company) { Company.find_by(name: "Just the Right Piece") }

  context "visitor" do

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.slogan)
    end

    scenario "sees category links" do
      visit root_path

      expect(page).to have_link(category_1.name)
      expect(page).to have_link(category_2.name)
      expect(page).to have_link(category_3.name)
    end

    scenario "does not see edit category links" do
      visit root_path

      expect(page).not_to have_link("edit")
    end

    scenario "clicks a category link" do
      visit root_path
      click_link(category_1.name)

      expect(page).to have_content(category_1.name)
    end

  end

  context "internal user" do

    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).not_to have_content(company.slogan)

      expect(page).to have_link("Items")
      expect(page).to have_link("Categories")
      expect(page).to have_link("Clients")

      expect(page).to have_link("Quick-Add Item")
      expect(page).to have_link("Quick-Add Client")
      expect(page).to have_link("Create New Proposal")
      expect(page).to have_link("Open Proposals")
      expect(page).to have_link("Executed Agreements")

      expect(page).to have_content("Recent Items")
      expect(page).to have_content("Recent Sales")
    end

    scenario "clicks 'Items' link", js: true do
      visit root_path
      click_link("Items")

      expect(page).to have_link("Potential")
      expect(page).to have_link("Active")
      expect(page).to have_link("Sold")
    end

    scenario "clicks 'Categories' link", js: true do
      categories = create_list(:category, 3)
      visit root_path
      click_link("Categories")

      categories.each do |category|
        expect(page).to have_link(category.name)
      end
    end

    scenario "clicks 'Clients' link", js: true do
      visit root_path
      click_link("Clients")

      expect(page).to have_link("Active")
      expect(page).to have_link("Inactive")
    end

  end

end
