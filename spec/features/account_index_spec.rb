feature "account index" do

  let(:user) { create(:internal_user) }

  before do
    sign_in user
  end

  context "internal_user" do

    scenario "sees account list" do
      visit accounts_path

      expect(page).to have_content("Primary Contact:")
    end

    scenario "deactivates an account" do
      visit accounts_path
      click_link("Deactivate", match: :first)

      expect(page).to have_content("Account deactivated")
      expect(Account.inactive.count).to eq(1)
    end

  end

end
