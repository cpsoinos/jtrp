feature "view proposal" do

  context "company" do

    let(:user) { create(:internal_user) }
    let(:account) { create(:account, :company) }
    let(:job) { create(:job, account: account) }
    let(:proposal) { create(:proposal, job: job) }

    before do
      sign_in user
    end

    scenario "visits proposal page" do
      visit account_job_proposal_path(account, job, proposal)

      expect(page).to have_content("Proposal for #{account.full_name}")
    end

  end

end
