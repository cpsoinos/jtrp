feature "sign up" do

  scenario "visits root path" do
    visit root_path

    expect(page).to have_link("Sign Up")
  end

  scenario "clicks 'sign up'" do
    visit root_path
    click_link("Sign Up")

    expect(page).to have_content("Sign Up")
    expect(page).to have_field("user_email")
    expect(page).to have_field("user_password")
    expect(page).to have_field("user_password_confirmation")
    expect(page).to have_field("user_first_name")
    expect(page).to have_field("user_last_name")
    expect(page).to have_field("user_address_1")
    expect(page).to have_field("user_address_2")
    expect(page).to have_field("user_city")
    expect(page).to have_field("user_state")
    expect(page).to have_field("user_zip")
    expect(page).to have_field("user_phone")
    expect(page).to have_field("user_phone_ext")
    expect(page).to have_field("user_role")
    expect(page).to have_link("Sign Up")
    expect(page).to have_link("Log in")
  end

  scenario "successfully fills out 'sign up' form" do
    visit new_user_registration_path
    fill_in("user_email", with: "sally@seashell.com")
    fill_in("user_password", with: "supersecretsupersafe")
    fill_in("user_password_confirmation", with: "supersecretsupersafe")
    fill_in("user_first_name", with: "Sally")
    fill_in("user_last_name", with: "Seashell")
    fill_in("user_address_1", with: "35 Tropic Schooner")
    fill_in("user_address_2", with: "Pool 1")
    fill_in("user_city", with: "Naples")
    fill_in("user_state", with: "FL")
    fill_in("user_zip", with: "12345")
    fill_in("user_phone", with: "1234567890")
    fill_in("user_phone_ext", with: "123")
    click_on("Sign up")

    expect(page).to have_content("Welcome! You have signed up successfully.")
  end

  scenario "unsuccessfully fills out 'sign up' form" do
    visit new_user_registration_path
    fill_in("user_password", with: "supersecretsupersafe")
    fill_in("user_password_confirmation", with: "supersecretsupersafe")
    fill_in("user_first_name", with: "Sally")
    fill_in("user_last_name", with: "Seashell")
    fill_in("user_address_1", with: "35 Tropic Schooner")
    fill_in("user_address_2", with: "Pool 1")
    fill_in("user_city", with: "Naples")
    fill_in("user_state", with: "FL")
    fill_in("user_zip", with: "12345")
    fill_in("user_phone", with: "1234567890")
    fill_in("user_phone_ext", with: "123")
    click_on("Sign up")

    expect(page).not_to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_content("Email can't be blank")
  end

  context "new client" do
    scenario "successfully signs up as a client", js: true do
      visit new_user_registration_path
      fill_in("user_email", with: "sally@seashell.com")
      fill_in("user_password", with: "supersecretsupersafe")
      fill_in("user_password_confirmation", with: "supersecretsupersafe")
      fill_in("user_first_name", with: "Sally")
      fill_in("user_last_name", with: "Seashell")
      fill_in("user_address_1", with: "35 Tropic Schooner")
      fill_in("user_address_2", with: "Pool 1")
      fill_in("user_city", with: "Naples")
      fill_in("user_state", with: "FL")
      fill_in("user_zip", with: "12345")
      fill_in("user_phone", with: "1234567890")
      fill_in("user_phone_ext", with: "123")
      check("user_role")

      expect(page).to have_content("Consignment Policies")

      check("user[consignment_policy_accepted]")
      click_on("Close")
      click_on("Sign up")
      expect(page).to have_content("Welcome! You have signed up successfully.")
    end

    scenario "does not agree to policies", js: true do
      visit new_user_registration_path
      fill_in("user_email", with: "sally@seashell.com")
      fill_in("user_password", with: "supersecretsupersafe")
      fill_in("user_password_confirmation", with: "supersecretsupersafe")
      fill_in("user_first_name", with: "Sally")
      fill_in("user_last_name", with: "Seashell")
      fill_in("user_address_1", with: "35 Tropic Schooner")
      fill_in("user_address_2", with: "Pool 1")
      fill_in("user_city", with: "Naples")
      fill_in("user_state", with: "FL")
      fill_in("user_zip", with: "12345")
      fill_in("user_phone", with: "1234567890")
      fill_in("user_phone_ext", with: "123")
      check("user_role")

      click_on("Close")
      expect(page).to have_button("Sign up", disabled: true)
    end
  end

end
