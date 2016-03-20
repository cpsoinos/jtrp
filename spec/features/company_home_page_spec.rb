feature "home page" do

  context "visitor" do

    let(:company) { create(:company) }
    let!(:category_1) { create(:category, company: company) }
    let!(:category_2) { create(:category, company: company) }
    let!(:category_3) { create(:category, company: company) }

    scenario "visits home page" do
      visit company_path(company)

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.description)
    end

    scenario "sees category links" do
      visit company_path(company)

      expect(page).to have_link(category_1.name)
      expect(page).to have_link(category_2.name)
      expect(page).to have_link(category_3.name)
    end

    scenario "clicks a category link" do
      visit company_path(company)
      click_link(category_1.name)

      expect(page).to have_content(category_1.name)
    end

  end

end
