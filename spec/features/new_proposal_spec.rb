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

      let(:proposal) { create(:proposal, account: client.account)}

      scenario "an existing client" do
        visit new_proposal_path

        expect(page).to have_select("proposal_account_id", with_options: [client.full_name])
      end

      scenario "selects an existing client" do
        visit new_proposal_path
        select(client.full_name, from: "proposal_account_id")
        click_button("Next")

        expect(page).to have_content("Step 1")
        expect(page).to have_content("Choose an existing item")
        expect(page).to have_content("Add a New Item")
        expect(page).to have_field("item_description")
        expect(page).to have_field("item[initial_photos][]")
        expect(page).not_to have_field("item_listing_price")
        expect(page).not_to have_field("item_minimum_sale_price")
        expect(page).not_to have_field("item_condition")
        expect(page).to have_button("Create Item")
        expect(Proposal.count).to eq(1)
      end

      scenario "does not select a client" do
        visit new_proposal_path
        click_button("Next")

        expect(page).to have_content("Account can't be blank")
        expect(Proposal.count).to eq(0)
      end

      scenario "successfully fills in proposal information", js: true do
        visit edit_proposal_path(proposal)
        fill_in("item_description", with: "Chair")
        attach_file('item[initial_photos][]', [File.join(Rails.root, '/spec/fixtures/test.png'), File.join(Rails.root, '/spec/fixtures/test_2.png')])
        click_on("Create Item")

        expect(page).to have_content("Chair")
        expect(page).to have_css("img[src*='test.png']")
        expect(page).to have_css("img[src*='test_2.png']")
      end

      scenario "removes an item", js: true do
        item = create(:item, proposal: proposal)
        visit edit_proposal_path(proposal)

        expect(page).to have_content(item.description)

        click_on("Remove")

        expect(page).not_to have_content(item.description)
      end

      scenario "uploads a batch of items" do
        visit edit_proposal_path(proposal)
        attach_file("item[archive]", File.join(Rails.root, '/spec/fixtures/archive.zip'))
        click_on("Upload Archive")

        expect(page).to have_content("microwave")
        expect(page).to have_content("dish washer")
        expect(page).to have_css("img[src*='test_3.png']")
        expect(page).to have_css("img[src*='test_4.png']")
        expect(page).to have_css("img[src*='test_5.png']")
        expect(page).to have_css("img[src*='test_6.png']")
        expect(Item.count).to eq(2)
      end

      context "item details" do
        let!(:item) { create(:item, proposal: proposal, account: proposal.account) }

        scenario "chooses offer type", js: true do
          visit edit_proposal_path(proposal)
          click_link("Step 2: Details")

          expect(page).to have_content("Proposal Details for #{client.full_name}")
          expect(page).to have_field("item_#{item.id}_offer_type_purchase")
          expect(page).to have_field("item_#{item.id}_offer_type_consign")

          choose("item_#{item.id}_offer_type_purchase")
          wait_for_ajax
          item.reload

          expect(item.offer_type).to eq("purchase")

          choose("item_#{item.id}_offer_type_consign")
          wait_for_ajax
          item.reload

          expect(item.offer_type).to eq("consign")
        end

        scenario "adds purchase offer price", js: true do
          visit proposal_details_path(proposal)
          choose("item_#{item.id}_offer_type_purchase")
          bip_text(item, :purchase_price, "5")

          expect(page).to have_content("$5.00")

          wait_for_ajax
          item.reload

          expect(item.purchase_price_cents).to eq(500)
        end

        scenario "adds consignment offer price", js: true do
          visit proposal_details_path(proposal)
          choose("item_#{item.id}_offer_type_consign")
          bip_text(item, :listing_price, "10")
          bip_text(item, :minimum_sale_price, "5")

          expect(page).to have_content("$10.00")
          expect(page).to have_content("$5.00")

          wait_for_ajax
          item.reload

          expect(item.listing_price_cents).to eq(1000)
          expect(item.minimum_sale_price_cents).to eq(500)
        end

        scenario "changes offer type and price", js: true do
          visit proposal_details_path(proposal)
          choose("item_#{item.id}_offer_type_consign")
          bip_text(item, :listing_price, "10")
          bip_text(item, :minimum_sale_price, "5")

          expect(page).to have_content("$10.00")
          expect(page).to have_content("$5.00")

          wait_for_ajax
          item.reload

          expect(item.listing_price_cents).to eq(1000)
          expect(item.minimum_sale_price_cents).to eq(500)

          choose("item_#{item.id}_offer_type_purchase")
          wait_for_ajax
          item.reload

          bip_text(item, :purchase_price, "7")

          expect(page).to have_content("$7.00")
          expect(page).not_to have_content("$10.00")
          expect(page).not_to have_content("$5.00")

          wait_for_ajax
          item.reload

          expect(item.listing_price_cents).to be(nil)
          expect(item.minimum_sale_price_cents).to be(nil)
          expect(item.purchase_price_cents).to eq(700)
        end

        scenario "views completed proposal" do
          visit proposal_details_path(proposal)
          click_link("View Proposal")

          expect(page).to have_content("This proposal is not binding and shall not be deemed an enforceable contract. It is for information purposes only.")
          expect(page).to have_content("Item ##{item.id}")
          expect(page).to have_content(item.description)
          expect(page).to have_content("Purchase Offer")
          expect(page).to have_content("Consignment Offer")
          expect(page).to have_link("Response Form")
        end

      end

      scenario "generates a proposal for the client" do
        item = create(:item, proposal: proposal)
        visit proposal_path(proposal)

        expect(page).to have_content("This proposal is not binding and shall not be deemed an enforceable contract. It is for information purposes only.")
        expect(page).to have_content("Item ##{item.id}")
        expect(page).to have_content(item.description)
        expect(page).to have_content("Purchase Offer")
        expect(page).to have_content("Consignment Offer")
        expect(page).to have_link("Response Form")
      end

      scenario "generates a proposal response form for the client" do
        item = create(:item, proposal: proposal, account: proposal.account)
        visit proposal_response_form_path(proposal)

        expect(page).to have_content("Proposal Response")
        expect(page).to have_content(item.id)
        expect(page).to have_content(item.description)
        %w(sell consign donate dump move nothing).each do |intention|
          expect(page).to have_content(intention)
        end
      end

    end

    context "new client" do

      scenario "successfully creates a new client" do
        visit new_proposal_path
        click_on("New Client")

        fill_in("client_email", with: "sally@salamander.com")
        fill_in("client_first_name", with: "Sally")
        fill_in("client_last_name", with: "Salamander")
        fill_in("client_address_1", with: "3 Tropic Schooner")
        fill_in("client_address_2", with: "Pool 1")
        fill_in("client_state", with: "FL")
        fill_in("client_zip", with: "12345")
        click_on("Create Client")

        expect(page).to have_content("Step 1")
      end

      scenario "unsuccessfully creates a new client" do
        visit new_proposal_path
        click_on("New Client")

        fill_in("client_first_name", with: "Sally")
        fill_in("client_last_name", with: "Salamander")
        fill_in("client_address_1", with: "3 Tropic Schooner")
        fill_in("client_address_2", with: "Pool 1")
        fill_in("client_state", with: "FL")
        fill_in("client_zip", with: "12345")
        click_on("Create Client")

        expect(page).to have_content("Email can't be blank")
      end

    end

  end

end
