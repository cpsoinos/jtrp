feature "edit a proposal" do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let(:job) { proposal.job }
  let(:account) { job.account }

  context "visitor" do
    scenario "visits edit proposal path" do
      visit edit_account_job_proposal_path(account, job, proposal)

      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in user
    end

    scenario "successfully adds an item", js: true do
      pending("carrierwave_direct test fixes")
      visit edit_account_job_proposal_path(account, job, proposal)

      fill_in("item_description", with: "Chair")
      attach_file('item[initial_photos][]', [File.join(Rails.root, '/spec/fixtures/test.png'), File.join(Rails.root, '/spec/fixtures/test_2.png')])
      click_on("Create Item")

      expect(page).to have_content("Chair")
      expect(page).to have_css("img[src*='test.png']")
      expect(page).to have_css("img[src*='test_2.png']")
    end

    scenario "removes an item", js: true do
      pending("carrierwave_direct test fixes")
      item = create(:item, proposal: proposal)
      visit edit_account_job_proposal_path(account, job, proposal)

      expect(page).to have_content(item.description)

      click_on("Remove")

      expect(page).not_to have_content(item.description)
    end

    scenario "uploads a batch of items" do
      pending("carrierwave_direct test fixes")
      visit edit_account_job_proposal_path(account, job, proposal)
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
      let!(:item) { create(:item, proposal: proposal) }

      scenario "arrives at details path" do
        pending("carrierwave_direct test fixes")
        visit edit_account_job_proposal_path(account, job, proposal)
        click_link("Step 2: Details")

        expect(page).to have_content("Proposal Details for #{account.full_name}")
        expect(page).to have_content("will purchase:")
        expect(page).to have_content("will consign:")
      end

      scenario "offers to purchase", js: true do
        visit account_job_proposal_details_path(account, job, proposal)
        expect(item.will_purchase?).to be_falsey
        find(:css, "#item_#{item.id}_will_purchase", visible: false).trigger("click")
        fill_in("item_purchase_price", with: 50.55)
        click_on("Update Item")
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

        click_on("Update Item")
        wait_for_ajax
        item.reload

        expect(item.will_consign?).to be_truthy
        expect(item.consignment_rate).to eq(45)
        expect(item.listing_price_cents).to eq(8889)
        expect(item.minimum_sale_price_cents).to eq(6755)
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

        click_on("Update Item")
        wait_for_ajax
        item.reload

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

  end

end
