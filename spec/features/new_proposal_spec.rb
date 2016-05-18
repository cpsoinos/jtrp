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
    let(:user) { create(:internal_user) }
    let!(:client) { create(:client) }

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
        expect(page).to have_field("initial_photos[]")
        expect(page).to have_field("item_listing_price")
        expect(page).to have_field("item_minimum_sale_price")
        expect(page).to have_field("item_condition")
        expect(page).to have_button("Add Item")
        expect(Proposal.count).to eq(1)
      end

      scenario "does not select a client" do
        visit new_proposal_path
        click_button("Next")

        expect(page).to have_content("Client can't be blank")
        expect(Proposal.count).to eq(0)
      end

      let(:proposal) { create(:proposal, client: client)}

      scenario "successfully fills in proposal information", js: true do
        visit edit_proposal_path(proposal)
        fill_in("item_name", with: "Chair")
        fill_in("item_description", with: "sit in it")
        attach_file('initial_photos[]', [File.join(Rails.root, '/spec/fixtures/test.png'), File.join(Rails.root, '/spec/fixtures/test_2.png')])
        fill_in("item_listing_price", with: "55")
        fill_in("item_minimum_sale_price", with: "45")
        fill_in("item_condition", with: "like new")
        click_on("Add Item")

        expect(page).to have_content("sit in it")
        expect(page).to have_css("img[src*='test.png']")
        expect(page).to have_css("img[src*='test_2.png']")
        expect(page).to have_content("$55")
        expect(page).to have_content("$45")
        expect(page).to have_content("like new")
      end

      scenario "deletes an item" do
        create(:item, proposal: proposal)
        visit edit_proposal_path(proposal)
        click_on("Delete")

        expect(page).to have_content("Item removed")
      end

      scenario "generates a proposal for the client" do
        item = create(:item, proposal: proposal)
        visit proposal_path(proposal)

        expect(page).to have_content("This proposal is not binding and shall not be deemed an enforceable contract. It is for information purposes only.")
        expect(page).to have_content("Item ##{item.id}")
        expect(page).to have_content(item.name)
        expect(page).to have_content("Purchase Offer")
        expect(page).to have_content("Consignment Offer")
        expect(page).to have_link("Response Form")
      end

      scenario "generates a proposal response form for the client" do
        item = create(:item, proposal: proposal)
        visit proposal_response_form_path(proposal)

        expect(page).to have_content("Proposal Response")
        expect(page).to have_content(item.id)
        expect(page).to have_content(item.name)
        %w(sell consign donate dump move nothing).each do |intention|
          expect(page).to have_content(intention)
        end
      end

    end

    context "new client" do

      scenario "successfully creates a new client" do
        visit new_proposal_path
        click_on("New Client")

        fill_in("user_email", with: "sally@salamander.com")
        fill_in("user_first_name", with: "Sally")
        fill_in("user_last_name", with: "Salamander")
        fill_in("user_address_1", with: "3 Tropic Schooner")
        fill_in("user_address_2", with: "Pool 1")
        fill_in("user_state", with: "FL")
        fill_in("user_zip", with: "12345")
        click_on("Create Client")

        expect(page).to have_content("Add an Item")
      end

      scenario "unsuccessfully creates a new client" do
        visit new_proposal_path
        click_on("New Client")

        fill_in("user_first_name", with: "Sally")
        fill_in("user_last_name", with: "Salamander")
        fill_in("user_address_1", with: "3 Tropic Schooner")
        fill_in("user_address_2", with: "Pool 1")
        fill_in("user_state", with: "FL")
        fill_in("user_zip", with: "12345")
        click_on("Create Client")

        expect(page).to have_content("Email can't be blank")
      end

    end

  end

end
