feature "item show" do

  let(:user) { create(:internal_user) }

  before do
    sign_in user
  end

  context "potential" do

    let(:item) { create(:item) }
    let(:proposal) { item.proposal }
    let(:job) { item.job }
    let(:account) { item.account }

    scenario "visits item show page" do
      visit account_job_proposal_item_path(account, job, proposal, item)

      expect(page).to have_content(account.id)
      expect(page).to have_content(job.id)
      expect(page).to have_content(proposal.id)
      expect(page).to have_content(item.account_item_number)
      expect(page).to have_content(item.id)
      expect(page).to have_link("delete_forever".html_safe)
      expect(page).to have_link("edit")
      expect(page).to have_content("potential")
    end

    scenario "internal user successfully marks an item active" do
      allow(InventorySyncJob).to receive(:perform_async)
      item.update_attribute("client_intention", "sell")
      agreement = create(:agreement, :active, proposal: proposal)
      visit account_job_proposal_item_path(account, job, proposal, item)

      click_link("Activate")
      expect(page).to have_content("Item activated!")
      expect(item.reload).to be_active
    end

    scenario "internal user unsuccessfully marks an item active" do
      agreement = create(:agreement, proposal: proposal)
      visit account_job_proposal_item_path(account, job, proposal, item)

      click_link("Activate")
      expect(page).to have_content("Could not activate item. Check that the agreement is active first.")
      expect(item.reload).to be_potential
    end

  end

  context "inactive" do

    let(:item) { create(:item, :inactive) }

    scenario "internal user successfully marks an item active" do
      allow(InventorySyncJob).to receive(:perform_async)
      visit item_path(item)

      click_link("Activate")
      expect(page).to have_content("Item activated!")
      expect(item.reload).to be_active
    end

  end

  context "active" do

    context "for sale" do
      let(:item) { create(:item, :active, listing_price_cents: 1111) }
      let(:proposal) { item.proposal }
      let(:job) { item.job }
      let(:agreement) { item.agreement }
      let(:account) { item.account }

      before do
        visit account_job_proposal_item_path(account, job, proposal, item)
      end

      scenario "visits item show page" do
        expect(page).to have_content(account.id)
        expect(page).to have_content(job.id)
        expect(page).to have_content(proposal.id)
        expect(page).to have_content(item.account_item_number)
        expect(page).to have_content(item.id)
        expect(page).to have_content(agreement.id)
        expect(page).to have_link("delete_forever".html_safe)
        expect(page).to have_link("edit")
        expect(page).to have_content("active")
        expect(page).to have_content("Owned")
        expect(page).to have_content("$11.11")
      end

      scenario "marks as sold" do
        allow(Clover::Inventory).to receive(:delete)
        click_link("Mark as Sold")
        expect(page).to have_field("item[sale_price]")
        expect(page).to have_field("item[sold_at]")

        fill_in("item[sale_price]", with: 64.66)
        fill_in("item[sold_at]", with: "07/04/2016")
        click_button("Update Item")
        item.reload

        expect(page).to have_content("Item was successfully updated")
        expect(item).to be_sold
        expect(item.sale_price_cents).to eq(6466)
        expect(item.sold_at).to eq("04/07/2016".to_datetime)
      end

      scenario "marks expired" do
        allow(Clover::Inventory).to receive(:update)
        click_link("Mark Expired")

        item.reload
        expect(page).to have_content("Item was successfully updated.")
        expect(item.expired?).to be_truthy
        expect(page).to have_link("Unmark Expired")
      end

      scenario "unmarks expired" do
        allow(Clover::Inventory).to receive(:update)
        item.update_attribute("expired", true)
        visit item_path(item)
        click_link("Unmark Expired")

        item.reload
        expect(page).to have_content("Item was successfully updated.")
        expect(item.expired?).to be_falsey
        expect(page).to have_link("Mark Expired")
      end

    end

    context "consigned" do
      let(:item) { create(:item, :active, client_intention: "consign", listing_price_cents: 1111, minimum_sale_price_cents: 1010, consignment_rate: 45) }
      let(:proposal) { item.proposal }
      let(:job) { item.job }
      let(:account) { item.account }

      before do
        visit account_job_proposal_item_path(account, job, proposal, item)
      end

      scenario "visits item show page" do
        expect(page).to have_content(account.id)
        expect(page).to have_content(job.id)
        expect(page).to have_content(proposal.id)
        expect(page).to have_content(item.account_item_number)
        expect(page).to have_content(item.id)
        expect(page).to have_link("delete_forever".html_safe)
        expect(page).to have_link("edit")
        expect(page).to have_content("active")
        expect(page).to have_content("at 45.0%")
        expect(page).to have_content("$11.11")
        expect(page).to have_content("Min. Price:")
        expect(page).to have_content("$10.10")
      end

      scenario "internal user successfully marks an item inactive" do
        allow(InventorySyncJob).to receive(:perform_async)
        visit item_path(item)

        click_link("Other")
        expect(page).to have_content("Item deactivated")
        expect(item.reload).to be_inactive
      end

    end

    context "sold" do
      let(:item) { create(:item, :sold, listing_price_cents: 1111, sale_price_cents: 1111) }
      let(:proposal) { item.proposal }
      let(:job) { item.job }
      let(:agreement) { item.agreement }
      let(:account) { item.account }

      scenario "item has no sale date" do
        visit account_job_proposal_item_path(account, job, proposal, item)

        expect(page).to have_content("Sold for $11.11")
        expect(page).not_to have_content("Sold for $11.11 on")
      end

      scenario "item has a sale date" do
        Timecop.freeze("October 10, 2016")
        item.update_attribute("sold_at", DateTime.now)
        visit account_job_proposal_item_path(account, job, proposal, item)

        expect(page).to have_content("Sold for $11.11 on 10/10/16")
        Timecop.return
      end

      scenario "marks item as not sold" do
        allow(InventorySyncJob).to receive(:perform_async)
        visit account_job_proposal_item_path(account, job, proposal, item)
        click_link("Mark Not Sold")
        item.reload

        expect(page).to have_content("Item marked as not sold.")
        expect(item).to be_active
        expect(item.agreement).to be_active
        expect(item.sale_price_cents).to be(nil)
        expect(item.sold_at).to be(nil)
        expect(item.order).to be(nil)
      end
    end

  end

end
