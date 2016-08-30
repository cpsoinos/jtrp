feature "agreement" do

  let(:user) { create(:internal_user) }
  let(:account) { create(:account, :with_client) }
  let(:client) { account.primary_contact }
  let(:job) { create(:job, account: account) }
  let(:proposal) { create(:proposal, created_by: user, job: job) }
  let(:syncer) { double("syncer") }

  before do
    allow(TransactionalEmailJob).to receive(:perform_later)
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
    allow(syncer).to receive(:remote_destroy).and_return(true)
  end

  context "guest" do
    scenario "visits consignment agreement path" do
      visit account_job_proposal_agreements_path(account, job, proposal)

      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in(user)
    end

    context "sell" do

      let!(:item) { create(:item, proposal: proposal, client_intention: "sell") }
      let!(:agreement) { create(:agreement, :sell, proposal: proposal) }

      scenario "client intends to sell an item", js: true do
        visit account_job_proposal_agreements_path(account, job, proposal)

        expect(page).not_to have_link("consign")
        expect(page).not_to have_link("dump")
        expect(page).not_to have_link("donate")

        click_link("sell")

        expect(page).to have_content("Purchase Invoice")
      end

      scenario "uploads scanned agreement", js: true do
        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("sell")
        attach_file('scanned_agreement[scan]', File.join(Rails.root, '/spec/fixtures/test.pdf'))
        click_on("Create Scanned agreement")

        expect(page).to have_selector('iframe')
        expect(agreement.reload).to be_active
      end

      scenario "uploads an updated scanned agreement", js: true do
        scanned_agreement = create(:scanned_agreement)
        agreement = scanned_agreement.agreement

        visit account_job_proposal_agreements_path(agreement.account, agreement.job, agreement.proposal)
        click_link("sell")
        attach_file('scanned_agreement[scan]', File.join(Rails.root, '/spec/fixtures/test.pdf'))
        click_on("Update Scanned agreement")

        expect(page).to have_content("Agreement updated!")
        expect(page).to have_selector('iframe')
        expect(agreement.reload).to be_active
      end

    end

    context "consign" do

      let!(:item) { create(:item, proposal: proposal, client_intention: "consign") }
      let!(:agreement) { create(:agreement, :consign, proposal: proposal) }
      let(:syncer) { double("syncer") }

      before do
        Company.first.update_attribute("primary_contact_id", user.id)
        allow(InventorySync).to receive(:new).and_return(syncer)
        allow(syncer).to receive(:remote_create).and_return(true)
        visit account_job_proposal_agreements_path(account, job, proposal)
      end

      before :each, js: true do
        page.execute_script("$($('a[role=tab]')[0]).tab('show');")
      end

      scenario "visits consignment agreement path" do
        expect(page).not_to have_link("sell")
        expect(page).not_to have_link("dump")
        expect(page).not_to have_link("donate")

        click_link("consign")

        expect(page).to have_content("Consignment Agreement")
      end

      scenario "manager agrees", skip: "not requiring manager signature", js: true do
        first('input[name="agreement[manager_agreed]"]', visible: :false).set(true)
        click_button("consign-manager-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.manager_agreed).to be(true)
      end

      scenario "both client and manager sign", js: true do
        pending("client portal")
        first('input[name="agreement[manager_agreed]"]', visible: :false).set(true)
        click_button("consign-manager-submit")
        first('input[name="agreement[client_agreed]"]', visible: :false).set(true)
        click_button("consign-client-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.client_agreed).to be(true)
        expect(agreement.manager_agreed).to be(true)
        expect(agreement).to be_active
      end

    end

  end

  context "client" do

    let!(:item) { create(:item, proposal: proposal, client_intention: "consign") }
    let!(:agreement) { create(:agreement, :consign, proposal: proposal) }

    before do
      allow(PdfGeneratorJob).to receive(:perform_later)
      allow(TransactionalEmailJob).to receive(:perform_later)
      allow(InventorySync).to receive(:new).and_return(syncer)
    end

    scenario "there is legal verbiage around the clickwrap" do
      visit account_job_proposal_agreement_path(account, job, proposal, agreement)

      expect(page).to have_content("By checking the box below and accepting this agreement, you signify your acceptance of our terms. You will receive a copy of the executed agreement by email upon accepting.")
    end

    scenario "client agrees" do
      Timecop.freeze(Time.now)
      visit account_job_proposal_agreement_path(account, job, proposal, agreement)
      first('input[name="agreement[client_agreed]"]', visible: :false).set(true)
      click_button("I Accept")
      agreement.reload

      expect(page).to have_content("#{account.full_name} accepted the terms of this agreement at #{DateTime.now.strftime('%l:%M %p on %B %d, %Y')}.")
      expect(agreement.client_agreed).to be(true)
      Timecop.return
    end

  end

end
