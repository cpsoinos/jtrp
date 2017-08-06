feature "letters index" do

  let(:user) { create(:internal_user) }
  let!(:expiration_pending_letter) { create(:letter) }
  let!(:expiration_notice_letter) { create(:letter, :expiration_notice) }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits account list page" do
      visit accounts_path
      expect(page).to have_link("View Letters")
    end

    scenario "clicks through from accounts page", :js do
      skip("Figuring out what's up with this test")
      visit accounts_path
      first(:link, "View Letters", visible: false).click

      expect(page).to have_content("Letters")
      expect(page).to have_content("for #{expiration_pending_letter.account.full_name}")
    end

  end

end
