feature "add an account" do

  let(:user) { create(:internal_user) }

  it "requires authentication" do
    visit new_account_path

    expect(page).to have_content("You must be logged in to access this page!")
  end

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits new account path from home page" do
      visit dashboard_path
      click_link("add Account")

      expect(page).to have_content("Is this a company?")
      expect(page).to have_field("Company name", visible: false)
      expect(page).to have_field("Notes", visible: false)
    end

    context "not a company" do

      scenario "chooses not a company" do
        visit new_account_path
        click_link("No")

        expect(page).to have_content("New Client")
        expect(page).to have_field("client_email")
        expect(page).to have_field("client_first_name")
        expect(page).to have_field("client_last_name")
        expect(page).to have_field("client_address_1")
        expect(page).to have_field("client_address_2")
        expect(page).to have_field("client_city")
        expect(page).to have_field("client_state")
        expect(page).to have_field("client_zip")
        expect(page).to have_field("client_phone")
        expect(page).to have_field("client_phone_ext")
        expect(page).to have_button("Create Client")
      end

      scenario "successfully creates a new client" do
        visit new_account_path
        click_link("No")

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
        expect(page).to have_content("Seashell")
        expect(Account.last.full_name).to eq("Sally Seashell")
      end

      scenario "unsuccessfully creates a new client" do
        visit new_account_path
        click_link("No")

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

    context "is a company" do

      scenario "chooses is a company" do
        visit new_account_path
        click_link("Yes")

        expect(page).to have_field("Company name")
        expect(page).to have_field("Notes")
      end

      scenario "new client" do
        visit new_account_path
        click_link("Yes")
        fill_in("Company name", with: "Blah, Inc.")
        fill_in("Notes", with: "blah ditty blah blah")
        click_button("Create Account")

        expect(page).to have_content("New Client")
        expect(page).to have_field("client_email")
        expect(page).to have_field("client_first_name")
        expect(page).to have_field("client_last_name")
        expect(page).to have_field("client_address_1")
        expect(page).to have_field("client_address_2")
        expect(page).to have_field("client_city")
        expect(page).to have_field("client_state")
        expect(page).to have_field("client_zip")
        expect(page).to have_field("client_phone")
        expect(page).to have_field("client_phone_ext")
        expect(page).to have_button("Create Client")
      end

      scenario "creates a new client" do
        visit new_account_path
        click_link("Yes")
        fill_in("Company name", with: "Blah, Inc.")
        fill_in("Notes", with: "blah ditty blah blah")
        click_button("Create Account")

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
        expect(page).to have_content("Blah, Inc.")
      end

      scenario "chooses an existing user as primary contact", js: true do
        client = create(:user, first_name: "Connor", last_name: "O'Connor")
        visit new_account_path
        click_link("Yes")
        fill_in("Company name", with: "Blah, Inc.")
        fill_in("Notes", with: "blah ditty blah blah")
        page.find(".dropdownjs").click

        within(".dropdownjs") do
          page.find('li', text: client.full_name).click
        end

        click_button("Create Account")

        expect(page).to have_content("Account created")
        expect(page).to have_content("Blah, Inc.")
        expect(page).to have_content(client.full_name)
      end

    end

  end


end
