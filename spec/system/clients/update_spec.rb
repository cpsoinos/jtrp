describe "update client" do

  let(:client) { create(:client) }

  it "requires authentication" do
    visit edit_client_path(client)

    expect(page).to have_content("You must be logged in to access this page!")
  end

  context "internal user" do

    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    scenario "visits client edit page" do
      visit edit_client_path(client)

      expect(page).to have_field("client_email")
      expect(page).not_to have_field("client_password")
      expect(page).not_to have_field("client_password_confirmation")
      expect(page).to have_field("client_first_name")
      expect(page).to have_field("client_last_name")
      expect(page).to have_field("client_address_1")
      expect(page).to have_field("client_address_2")
      expect(page).to have_field("client_city")
      expect(page).to have_field("client_state")
      expect(page).to have_field("client_zip")
      expect(page).to have_field("client_phone")
      expect(page).to have_field("client_phone_ext")
      expect(page).not_to have_field("client_role")
      expect(page).to have_button("Update Client")
    end

    scenario "successfully updates a client" do
      visit edit_client_path(client)
      fill_in("client_email", with: "sally@seashell.com")
      fill_in("client_first_name", with: "Sally")
      fill_in("client_last_name", with: "Seashell")
      fill_in("client_address_1", with: "35 Tropic Schooner")
      fill_in("client_address_2", with: "Pool 1")
      fill_in("client_city", with: "Naples")
      fill_in("client_state", with: "FL")
      fill_in("client_zip", with: "12345")
      fill_in("client_phone", with: "1234567890")
      fill_in("client_phone_ext", with: "123")
      click_on("Update Client")

      expect(page).to have_content("Client updated")
    end

    scenario "unsuccessfully updates a client" do
      visit edit_client_path(client)
      fill_in("client_email", with: "")
      click_on("Update Client")

      expect(page).to have_content("Email can't be blank")
    end

  end

end
