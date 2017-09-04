describe "account index" do

  let(:user) { create(:internal_user) }
  let!(:potential_accounts) { create_list(:account, 2, :with_client) }
  let!(:active_seller_accounts) { create_list(:account, 2, :active, :with_client) }
  let!(:active_consignor_accounts) { create_list(:account, 3, :active, :with_client) }
  let!(:active_accounts) { active_seller_accounts | active_consignor_accounts }
  let!(:inactive_accounts) { create_list(:account, 2, :inactive, :with_client) }

  before(:each) do
    sign_in user
  end

  context "internal_user" do

    scenario "filters to 'potential' accounts by default" do
      visit accounts_path

      potential_accounts.each do |acct|
        expect(page).to have_link(acct.inverse_full_name)
        expect(page).to have_content("Primary Contact: #{acct.client.full_name}")
        expect(page).to have_content(acct.id)
      end
    end

    scenario "clicks link to filter to active" do
      visit accounts_path
      click_link("Active")

      active_accounts.each do |acct|
        within("#account-#{acct.id}-row") do
          expect(page).to have_link(acct.inverse_full_name)
          expect(page).to have_content("Primary Contact: #{acct.client.full_name}")
          expect(page).to have_content(acct.id)
          expect(page).to have_link("Deactivate")
        end
      end
    end

    scenario "active consignor account links" do
      active_consignor_accounts.each do |acct|
        create(:job, :active, account: acct, proposals: [create(:proposal, :active, agreements: [create(:agreement, :consign, :active)])])
      end
      visit accounts_path(status: "active")

      active_consignor_accounts.each do |acct|
        within("#account-#{acct.id}-row") do
          expect(page).to have_link("View Statements")
          expect(page).to have_link("View Letters")
        end
      end
    end

    scenario "active seller account links" do
      visit accounts_path(status: "active")

      active_seller_accounts.each do |acct|
        within("#account-#{acct.id}-row") do
          expect(page).not_to have_link("View Statements")
          expect(page).not_to have_link("View Letters")
        end
      end
    end

    scenario "clicks link to filter to inactive" do
      visit accounts_path
      click_link("Inactive")

      inactive_accounts.each do |acct|
        within("#account-#{acct.id}-row") do
          expect(page).to have_link(acct.inverse_full_name)
          expect(page).to have_content("Primary Contact: #{acct.client.full_name}")
          expect(page).to have_content(acct.id)
          expect(page).to have_link("Reactivate")
        end
      end
    end

    scenario "deactivates an account" do
      visit accounts_path("active")
      click_link("Deactivate", match: :first)

      expect(page).to have_content("Account deactivated")
      expect(Account.inactive.count).to eq(3)
    end

    scenario "reactivates an account" do
      create(:account, :inactive)
      visit accounts_path(status: "inactive")
      click_link("Reactivate", match: :first)

      expect(page).to have_content("Account reactivated")
      expect(Account.inactive.count).to eq(2)
    end

  end

end
