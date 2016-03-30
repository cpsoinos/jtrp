feature "home page" do

  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let(:company) { Company.find_by(name: "Just the Right Piece") }

  context "visitor" do

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.description)
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

    let(:user) { create(:user, :internal) }

    before do
      sign_in user
    end

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.description)
    end

    scenario "sees category links" do
      visit root_path

      expect(page).to have_link(category_1.name)
      expect(page).to have_link(category_2.name)
      expect(page).to have_link(category_3.name)
    end

    scenario "sees edit category links" do
      visit root_path

      expect(page).to have_link("edit")
    end

    scenario "clicks a category link" do
      visit root_path
      click_link(category_1.name)

      expect(page).to have_content(category_1.name)
    end

  end

end
