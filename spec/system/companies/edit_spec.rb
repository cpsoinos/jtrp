describe "edit a company" do

  let(:user) { create(:internal_user) }
  let!(:company) { Company.first }

  context "internal_user" do

    before do
      sign_in user
    end

    scenario "clicks through from 'about us' page" do
      visit dashboard_path(company)
      click_link("Edit Just the Right Piece")

      expect(page).to have_field("Name")
    end

    scenario "successfully updates a company" do
      visit edit_company_path(company)
      fill_in("company_address_1", with: "35 Tropic Schooner")
      fill_in("company_address_2", with: "Pool 1")
      fill_in("company_city", with: "Naples")
      fill_in("company_state", with: "FL")
      fill_in("company_zip", with: "12345")
      fill_in("company_phone", with: "1234567890")
      click_on("Save")

      expect(page).to have_content("Changes saved!")
    end

  end

end
