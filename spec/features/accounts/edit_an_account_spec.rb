feature "edit an account" do

  let(:user) { create(:internal_user) }

  before do
    sign_in user
  end

  context "is a company" do

    let(:account) { create(:account, :company) }

    scenario "visits edit page from show" do
      visit account_path(account)
      within(".btn-group") do
        click_link("edit")
      end

      expect(page).to have_field("Company name")
      expect(page).to have_content("Primary contact")
      expect(page).to have_field("Notes")
      expect(page).to have_button("Update Account")
      expect(page).to have_link("Delete Account")
    end

    scenario "updates the account with no primary contact" do
      visit edit_account_path(account)
      fill_in("Company name", with: "Blah, Inc.")
      fill_in("Notes", with: "blah ditty blah blah")
      click_button("Update Account")

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

      account.reload
      expect(account.company_name).to eq("Blah, Inc.")
      expect(account.notes).to eq("blah ditty blah blah")
    end

    scenario "updates the account with a primary contact", js: true do
      client = create(:user, first_name: "Connor", last_name: "O'Connor")
      visit edit_account_path(account)
      page.find(".dropdownjs").click

      within(".dropdownjs") do
        page.find('li', text: client.full_name).click
      end

      click_button("Update Account")

      expect(page).to have_content("Account updated")
      expect(page).to have_content(account.company_name)
      expect(page).to have_content(client.full_name)

      account.reload
      expect(account.primary_contact).to eq(client)
    end

    scenario "updates the account with a primary contact that already has an account", js: true do
      client = create(:client, first_name: "Connor", last_name: "O'Connor")
      visit edit_account_path(account)
      page.find(".dropdownjs").click

      within(".dropdownjs") do
        page.find('li', text: client.full_name).click
      end

      click_button("Update Account")

      expect(page).to have_content("Account updated")
      expect(page).to have_content(account.company_name)
      expect(page).to have_content(client.full_name)

      account.reload
      expect(account.primary_contact).to eq(client)

      client.reload
      expect(client.account).not_to eq(account)
    end

  end

end
