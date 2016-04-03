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

      expect(page).to have_content("Step 1: Select a Client")
    end

    context "existing client" do

      scenario "an existing client" do
        visit new_proposal_path

        expect(page).to have_select("proposal_client_id", with_options: [client.full_name])
      end

      scenario "selects an existing client" do
        visit new_proposal_path
        select(client.full_name, from: "proposal_client_id")
        click_button("Next")

        expect(page).to have_content("Add an Item")
        expect(page).to have_field("item_name")
        expect(page).to have_field("item_description")
        expect(page).to have_field("item_initial_photos")
        expect(page).to have_field("item_listing_price")
        expect(page).to have_field("item_minimum_sale_price")
        expect(page).to have_field("item_condition")
        expect(page).to have_button("Add Item")
      end

      let(:proposal) { create(:proposal, client: client)}

      scenario "successfully fills in proposal information", js: true do
        visit edit_proposal_path(proposal)
        fill_in("item_name", with: "Chair")
        fill_in("item_description", with: "sit in it")
        attach_file('item_initial_photos', File.join(Rails.root, '/spec/fixtures/test.png'))
        fill_in("item_listing_price", with: "55")
        fill_in("item_minimum_sale_price", with: "45")
        fill_in("item_condition", with: "like new")
        click_on("Add Item")

        expect(page).to have_content("sit in it")
        expect(page).to have_selector("img[src$='test.png']")
        expect(page).to have_content("$55")
        expect(page).to have_content("$45")
        expect(page).to have_content("like new")
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
