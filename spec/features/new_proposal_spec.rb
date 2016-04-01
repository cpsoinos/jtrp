feature "new proposal" do

  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let(:company) { Company.find_by(name: "Just the Right Piece") }

  context "visitor" do
    scenario "visit root path" do
      visit root_path

      expect(page).not_to have_link("New Proposal")
    end
  end

  context "internal user" do
    let(:user) { create(:user, :internal) }
    let!(:client) { create(:user, :client) }

    before do
      sign_in user
    end

    scenario "visit root path" do
      visit root_path

      expect(page).to have_link("New Proposal")
    end

    scenario "clicks 'New Proposal' link" do
      visit root_path
      click_link("New Proposal")

      expect(page).to have_select("Client", with_options: [client.full_name])
      # item fields
    end

    context "existing client" do

      scenario "fills in proposal information" do
        visit new_proposal_path

        select(client.full_name, from: "Client")

        # js
      end
    end

    context "new client", :pending do

      scenario "creates a new client" do
        visit new_proposal_path
        click_on("New Client")

        # js for form
      end

    end

  end

end
