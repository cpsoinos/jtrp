feature "company: about us" do

  context "guest" do

    scenario "sees links from home page" do
      visit root_path
      click_link("About Us", match: :first)

      expect(page).to have_link("Client Services")
      expect(page).to have_link("Consignment Policies")
    end

    scenario "clicks through to client services" do
      visit root_path
      click_link("About Us", match: :first)
      click_link("Client Services")

      within("h1") do
        expect(page).to have_content("Client Services")
      end
      expect(page).not_to have_link("Edit")
    end

    scenario "clicks through to consignment policies" do
      visit root_path
      click_link("About Us", match: :first)
      click_link("Consignment Policies")

      within("h1") do
        expect(page).to have_content("Consignment Policies")
      end
      expect(page).not_to have_link("Edit")
    end

  end

  context "internal user" do

    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    scenario "sees links from home page" do
      visit root_path
      click_link("About Us", match: :first)

      expect(page).to have_link("Client Services")
      expect(page).to have_link("Consignment Policies")
    end

    scenario "clicks through to client services" do
      visit root_path
      click_link("About Us", match: :first)
      click_link("Client Services")

      within("h1") do
        expect(page).to have_content("Client Services")
      end
      expect(page).to have_link("Edit")
    end

    scenario "clicks through to consignment policies" do
      visit root_path
      click_link("About Us", match: :first)
      click_link("Consignment Policies")

      within("h1") do
        expect(page).to have_content("Consignment Policies")
      end
    end

  end


end
