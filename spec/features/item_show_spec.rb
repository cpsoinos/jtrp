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
      expect(page).to have_content("Status:")
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
        expect(page).to have_content("Status:")
        expect(page).to have_content("active")
        expect(page).to have_content("For Sale")
        expect(page).to have_content("$11.11")
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
        expect(page).to have_content("Status:")
        expect(page).to have_content("active")
        expect(page).to have_content("Consigned at:")
        expect(page).to have_content("45.0%")
        expect(page).to have_content("Listed at:")
        expect(page).to have_content("$11.11")
        expect(page).to have_content("Min Price:")
        expect(page).to have_content("$10.10")
      end

    end

  end

end
