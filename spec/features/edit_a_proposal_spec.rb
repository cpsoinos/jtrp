feature "edit a proposal" do
  include CarrierWaveDirect::Test::CapybaraHelpers

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let(:job) { proposal.job }
  let(:account) { job.account }

  context "visitor" do
    scenario "visits edit proposal path" do
      visit edit_account_job_proposal_path(account, job, proposal)

      expect(page).to have_content("You must be logged in to access this page!")
    end
  end

  context "internal user" do

    before do
      sign_in user
    end

    context "item details" do
      let!(:item) { create(:item, proposal: proposal) }

      scenario "arrives at details path" do
        visit account_job_proposal_sort_items_path(account, job, proposal)
        click_link("Step 3: Item Details")

        expect(page).to have_content("Will purchase")
        expect(page).to have_content("Offer to purchase this item")
        expect(page).to have_content("Will consign")
        expect(page).to have_content("Offer to consign this item")
      end

      scenario "offers to purchase", js: true do
        visit account_job_proposal_details_path(account, job, proposal)
        expect(item.will_purchase?).to be_falsey
        find(:css, "#item_#{item.id}_will_purchase", visible: false).trigger("click")
        fill_in("item_purchase_price", with: 50.55)
        click_on("Save")
        wait_for_ajax
        item.reload

        expect(item.will_purchase?).to be_truthy
        expect(item.purchase_price_cents).to eq(5055)
      end

      scenario "offers to consign", js: true do
        visit account_job_proposal_details_path(account, job, proposal)
        expect(item.will_consign?).to be_falsey
        find(:css, "#item_#{item.id}_will_consign", visible: false).trigger("click")
        fill_in("item_consignment_rate", with: 45)
        fill_in("item_listing_price", with: 88.89)
        fill_in("item_minimum_sale_price", with: 67.55)

        click_on("Save")
        wait_for_ajax
        item.reload

        expect(item.will_consign?).to be_truthy
        expect(item.consignment_rate).to eq(45)
        expect(item.listing_price_cents).to eq(8889)
        expect(item.minimum_sale_price_cents).to eq(6755)
        expect(page).to have_content("Success!")
      end

      scenario "offers to both purchase and consign", js: true do
        visit account_job_proposal_details_path(account, job, proposal)
        expect(item.will_consign?).to be_falsey
        expect(item.will_purchase?).to be_falsey
        find(:css, "#item_#{item.id}_will_purchase", visible: false).trigger("click")
        fill_in("item_purchase_price", with: 50.55)
        find(:css, "#item_#{item.id}_will_consign", visible: false).trigger("click")
        fill_in("item_consignment_rate", with: 45)
        fill_in("item_listing_price", with: 88.89)
        fill_in("item_minimum_sale_price", with: 67.55)

        click_on("Save")
        wait_for_ajax
        item.reload

        expect(page).to have_content("Success!")
        expect(item.will_purchase?).to be_truthy
        expect(item.purchase_price_cents).to eq(5055)
        expect(item.will_consign?).to be_truthy
        expect(item.consignment_rate).to eq(45)
        expect(item.listing_price_cents).to eq(8889)
        expect(item.minimum_sale_price_cents).to eq(6755)
      end

      scenario "views completed proposal" do
        visit account_job_proposal_details_path(account, job, proposal)
        click_link("View Proposal")

        expect(page).to have_content("This proposal is not binding and shall not be deemed an enforceable contract. It is for information purposes only.")
        expect(page).to have_content("Item No. #{item.account_item_number}")
        expect(page).to have_content("SKU No. #{item.id}")
        expect(page).to have_content(item.description)
        expect(page).to have_content("Purchase Offer")
        expect(page).to have_content("Consignment Offer")
      end

    end

    scenario "generates a proposal for the client" do
      item = create(:item, proposal: proposal)
      visit account_job_proposal_path(account, job, proposal)

      expect(page).to have_content("This proposal is not binding and shall not be deemed an enforceable contract. It is for information purposes only.")
      expect(page).to have_content("Item No. #{item.account_item_number}")
      expect(page).to have_content("SKU No. #{item.id}")
      expect(page).to have_content(item.description)
      expect(page).to have_content("Purchase Offer")
      expect(page).to have_content("Consignment Offer")
    end

    scenario "sends a proposal to the client" do
      allow(TransactionalEmailJob).to receive(:perform_later)
      visit account_job_proposal_path(account, job, proposal)
      click_button("Send this Proposal")
      fill_in("note", with: "this is a note")
      click_button("Send Email")

      expect(TransactionalEmailJob).to have_received(:perform_later).with(proposal, Company.jtrp.primary_contact, account.primary_contact, "proposal", "this is a note")
    end

  end

end
