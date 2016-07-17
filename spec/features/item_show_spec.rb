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

    before do
      visit account_job_proposal_item_path(account, job, proposal, item)
    end

    scenario "visits item show page" do
      expect(page).to have_content(account.account_number)
      expect(page).to have_content(job.id)
      expect(page).to have_content(proposal.id)
      expect(page).to have_content(item.account_item_number)
      expect(page).to have_content(item.id)
      expect(page).to have_link("delete_forever".html_safe)
      expect(page).to have_link("edit")
      expect(page).to have_content("potential")
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
        expect(page).to have_content(account.account_number)
        expect(page).to have_content(job.id)
        expect(page).to have_content(proposal.id)
        expect(page).to have_content(item.account_item_number)
        expect(page).to have_content(item.id)
        expect(page).to have_content(agreement.id)
        expect(page).to have_link("delete_forever".html_safe)
        expect(page).to have_link("edit")
        expect(page).to have_content("active")
        expect(page).to have_content("For Sale")
        expect(page).to have_content("$11.11")
      end

      scenario "marks as sold", js: true do
        click_button("Mark as Sold")
        expect(page).to have_field("item[sale_price]")
        expect(page).to have_field("item[sold_at]")

        fill_in("item[sale_price]", with: 64.66)
        fill_in("item[sold_at]", with: "07/04/2016")
        click_button("Update Item")
        item.reload

        expect(item).to be_sold
        expect(item.sale_price_cents).to eq(6466)
        expect(item.sold_at).to eq("04/07/2016".to_datetime)
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
        expect(page).to have_content(account.account_number)
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

    end

  end

end
