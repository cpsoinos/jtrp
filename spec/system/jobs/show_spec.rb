describe "job show" do

  let(:user) { create(:internal_user) }

  before do
    sign_in user
  end

  context "internal_user" do

    scenario "client account" do
      account = create(:client_account)
      job = create(:job, account: account)
      proposal = create(:proposal, job: job)
      owned_items = create_list(:item, 3, :owned, proposal: proposal)
      consigned_items = create_list(:item, 3, :consigned, proposal: proposal)
      visit account_job_path(account, job)

      expect(page).to have_content("Job Number")
      expect(page).to have_content(job.id)
      expect(page).to have_content("Account Number")
      expect(page).to have_content(account.id)
      expect(page).to have_content("Items")
      expect(page).to have_content("Status")
      expect(page).to have_content("Proposals")
      expect(page).to have_content("Agreements")

      owned_items.each do |item|
        expect(page).to have_content(item.description.titleize)
        expect(page).to have_content("SKU: #{item.id}")
      end
      consigned_items.each do |item|
        expect(page).to have_content(item.description.titleize)
        expect(page).to have_content("SKU: #{item.id}")
      end
    end

    context "owner account" do
      let(:account) { create(:owner_account) }
      let(:job) { create(:job, account: account) }
      let!(:owned_items) { create_list(:item, 3, :owned, proposal: create(:proposal, job: job)) }
      let!(:consigned_items) { create_list(:item, 3, :consigned) }

      scenario "basic info" do
        visit account_job_path(account, job)

        expect(page).to have_content("Job Number")
        expect(page).to have_content(job.id)
        expect(page).to have_content("Account Number")
        expect(page).to have_content(account.id)
        expect(page).to have_content("Items")
        expect(page).to have_content("3")
        expect(page).to have_content("Status")
        expect(page).to have_content("Proposals")
        expect(page).to have_content("Agreements")
      end

      scenario "with items" do
        visit account_job_path(account, job)

        owned_items.each do |item|
          expect(page).to have_content(item.description.titleize)
          expect(page).to have_content("SKU: #{item.id}")
        end
        consigned_items.each do |item|
          expect(page).not_to have_content(item.description.titleize)
          expect(page).not_to have_content("SKU: #{item.id}")
        end
      end

    end

  end

end
