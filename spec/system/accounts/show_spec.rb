describe "account show" do

  let(:user) { create(:internal_user) }

  before do
    sign_in user
  end

  context "internal_user" do

    scenario "no primary contact" do
      account = create(:client_account)
      visit account_path(account)

      expect(page).to have_content("Account Number")
      expect(page).to have_content(account.id)
      expect(page).to have_content("No Name Provided")
      expect(page).to have_content("Status")
      expect(page).to have_content("Potential")
    end

    scenario "with primary contact" do
      account = create(:client_account, :with_client)
      visit account_path(account)

      expect(page).to have_content("Account Number")
      expect(page).to have_content(account.id)
      expect(page).to have_content("Primary Contact")
      expect(page).to have_content(account.primary_contact.full_name)
      expect(page).to have_content("Status")
      expect(page).to have_content("Potential")
    end

    context "owner account", skip: true do
      let(:account) { create(:owner_account) }
      let!(:owned_items) { create_list(:item, 3, :owned) }
      let!(:consigned_items) { create_list(:item, 3, :consigned) }

      scenario "basic info" do
        visit account_path(account)

        expect(page).to have_content("Account Number")
        expect(page).to have_content(account.id)
        expect(page).to have_content("Account Name")
        expect(page).to have_content("JTRP")
        expect(page).to have_content("Status")
        expect(page).to have_content("Potential")
      end

      scenario "with items" do
        visit account_path(account)

        owned_items.each do |item|
          expect(page).to have_content(item.description.titleize)
        end
        consigned_items.each do |item|
          expect(page).not_to have_content(item.description.titleize)
        end
      end

    end

  end

end
