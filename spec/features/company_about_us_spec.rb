feature "company: about us" do

  context "guest" do

    scenario "sees links from home page" do
      visit root_path
      click_link("About Us")

      expect(page).to have_link("Client Services")
      expect(page).to have_link("Consignment Policies")
      expect(page).to have_link("Service Rate Schedule")
      expect(page).to have_link("Service Rate Schedule for Agents")
    end

    scenario "clicks through to client services" do
      visit root_path
      click_link("About Us")
      click_link("Client Services")

      expect(page).to have_content("Just the Right Piece")
      expect(page).not_to have_link("Edit")
    end

    scenario "clicks through to consignment policies" do
      visit root_path
      click_link("About Us")
      click_link("Consignment Policies")

      expect(page).to have_content("Just the Right Piece")
      expect(page).not_to have_link("Edit")
    end

    scenario "clicks through to service rate schedule" do
      visit root_path
      click_link("About Us")
      click_link("Service Rate Schedule")

      expect(page).to have_content("Just the Right Piece")
      expect(page).not_to have_link("Edit")
    end

    scenario "clicks through to agent service rate schedule" do
      visit root_path
      click_link("About Us")
      click_link("Service Rate Schedule for Agents")

      expect(page).to have_content("Just the Right Piece")
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
      click_link("About Us")

      expect(page).to have_link("Client Services")
      expect(page).to have_link("Consignment Policies")
      expect(page).to have_link("Service Rate Schedule")
      expect(page).to have_link("Service Rate Schedule for Agents")
    end

    scenario "clicks through to client services" do
      visit root_path
      click_link("About Us")
      click_link("Client Services")

      expect(page).to have_content("Just the Right Piece")
      expect(page).to have_link("Edit")
    end

    scenario "clicks through to consignment policies" do
      visit root_path
      click_link("About Us")
      click_link("Consignment Policies")

      expect(page).to have_content("Just the Right Piece")
      expect(page).to have_link("Edit")
    end

    scenario "clicks through to service rate schedule" do
      visit root_path
      click_link("About Us")
      click_link("Service Rate Schedule")

      expect(page).to have_content("Just the Right Piece")
      expect(page).to have_link("Edit")
    end

    scenario "clicks through to agent service rate schedule" do
      visit root_path
      click_link("About Us")
      click_link("Service Rate Schedule for Agents")

      expect(page).to have_content("Just the Right Piece")
      expect(page).to have_link("Edit")
    end

  end


end
