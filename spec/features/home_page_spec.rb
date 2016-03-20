feature "home page" do

  context "visitor" do

    let(:company) { create(:company) }

    scenario "visits root path" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.description)
    end

  end


end
