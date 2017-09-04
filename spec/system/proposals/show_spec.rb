describe "proposal show" do

  let(:user) { create(:internal_user) }
  let(:account) { create(:account, :company) }
  let(:job) { create(:job, account: account) }
  let(:proposal) { create(:proposal, job: job) }

  before do
    sign_in user
  end

  it "redirects to new client page when client not present" do
    visit account_job_proposal_path(account, job, proposal)

    expect(page).to have_content("This account needs a primary contact!")
    expect(page).to have_content("New Client")
    expect(page).to have_field("client_email")
    expect(page).to have_field("client_first_name")
    expect(page).to have_field("client_last_name")
    expect(page).to have_field("client_address_1")
    expect(page).to have_field("client_address_2")
    expect(page).to have_field("client_city")
    expect(page).to have_field("client_state")
    expect(page).to have_field("client_zip")
    expect(page).to have_field("client_phone")
    expect(page).to have_field("client_phone_ext")
    expect(page).to have_button("Create Client")
  end

  it "does not redirect when client is present" do
    account.primary_contact = create(:client)
    account.save

    visit account_job_proposal_path(account, job, proposal)

    expect(page).to have_content("Proposal for #{account.full_name}")
  end

end
