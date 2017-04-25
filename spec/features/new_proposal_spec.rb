feature "new proposal" do

  context "visitor" do
    scenario "visit root path" do
      visit root_path

      expect(page).not_to have_link("New Proposal")
    end
  end

  context "internal user" do
    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    context "existing client" do

      let(:account) { create(:account, :with_client) }
      let(:job) { create(:job, account: account) }

      context "without an existing job" do
        scenario "new proposal from account page" do
          visit account_path(account)
          click_link("New Proposal")

          expect(page).to have_content("New Job")
          expect(page).to have_field("Address 1")
          expect(page).to have_field("Address 2")
          expect(page).to have_field("City")
          expect(page).to have_field("State")
          expect(page).to have_field("Zip")
        end
      end

      context "with an existing job" do
        let!(:job) { create(:job, account: account) }

        scenario "new proposal from account page" do
          visit account_path(account)
          click_link("New Proposal")

          expect(page).to have_content("Is this for an existing job?")
          expect(page).to have_link("Yes")
          expect(page).to have_link("No")
        end

        scenario "selects an existing job", js: true do
          visit new_account_proposal_path(account)
          click_link("Yes")
          first(:css, ".dd-select").trigger("click")
          first(:css, ".dd-option").trigger("click")
          click_on("Create Proposal")

          expect(page).to have_content("Step 1: Upload Photos")
        end

        scenario "not for an existing job" do
          visit new_account_proposal_path(account)
          click_link("No")

          expect(page).to have_content("New Job")
          expect(page).to have_field("Address 1")
          expect(page).to have_field("Address 2")
          expect(page).to have_field("City")
          expect(page).to have_field("State")
          expect(page).to have_field("Zip")
        end

      end
    end
  end

end
