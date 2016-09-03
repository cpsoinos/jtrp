feature "client show" do

  let(:user) { create(:internal_user) }
  let(:client) { create(:client) }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits show page" do
      visit client_path(client)

      expect(page).to have_link(client.id)
      expect(page).to have_link(client.account.id)
      expect(page).to have_content(client.full_name)
      expect(page).to have_content(client.email)
      expect(page).to have_content(client.address_1)
      expect(page).to have_content(client.address_2)
      expect(page).to have_content(client.city)
      expect(page).to have_content(client.state)
      expect(page).to have_content(client.zip)

      expect(page).to have_selector("img[alt$='Client Avatar']")
      expect(page).to have_selector("img[alt$='Client Address']")
    end

  end

  context "guest" do
    scenario "visits show page" do
      visit client_path(client)

      expect(page).to have_content("You must be logged in to access this page!")
    end
  end

end
