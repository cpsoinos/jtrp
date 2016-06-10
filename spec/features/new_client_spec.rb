feature "new client" do

  let(:user) { create(:internal_user) }

  it "requires authentication" do
    visit new_client_path

    expect(page).to have_content("Forbidden")
  end

  context "internal user" do

    before do
      sign_in user
    end

    scenario "successfully creates a new client" do
      visit new_client_path
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
      click_on("Create Client")

      expect(page).to have_content("Client created!")
    end

    scenario "unsuccessfully creates a new client" do
      visit new_client_path
      fill_in("client_first_name", with: "Sally")
      fill_in("client_last_name", with: "Seashell")
      fill_in("client_address_1", with: "35 Tropic Schooner")
      fill_in("client_address_2", with: "Pool 1")
      fill_in("client_city", with: "Naples")
      fill_in("client_state", with: "FL")
      fill_in("client_zip", with: "12345")
      fill_in("client_phone", with: "1234567890")
      fill_in("client_phone_ext", with: "123")
      click_on("Create Client")

      expect(page).to have_content("Email can't be blank")
    end

  end

end
